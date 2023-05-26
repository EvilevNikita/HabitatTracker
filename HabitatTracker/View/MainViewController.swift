//
//  HabitViewController.swift
//  HabitatTracker
//
//  Created by Nikita Ivlev on 20/5/23.
//

import SnapKit
import UIKit

protocol HabitViewProtocol: AnyObject {
    func refreshHabitsView()
}

class MainViewController: UIViewController, HabitViewProtocol {

    let helloLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Привет, \(User.shared.name)!"
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()

    let progressView = ProgressView()

    let habitTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "HabitCell")
        return tableView
    }()

    let addHabitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .customGreen
        button.layer.cornerRadius = 30

        // added three targets to change the color of the button while it is pressed
        button.addTarget(self, action: #selector(addHabitTapped), for: .touchUpInside)
        button.addTarget(self, action: #selector(buttonTouchedDown), for: .touchDown)
        button.addTarget(self, action: #selector(buttonTouchedUp), for: [.touchUpInside, .touchUpOutside])

        return button
    }()

    let plusLabel: UILabel = {
        let label = UILabel()
        label.text = "+"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 55)
        return label
    }()

    func refreshHabitsView() {
        self.habitTableView.reloadData()
    }

    @objc func addHabitTapped(sender: UIButton!) {
        let presenter = HabitPresenter(view: self, habitManager: HabitManager.shared)
        let createHabitVC = CreateHabitViewController(presenter: presenter, habitToEdit: nil)
        navigationController?.pushViewController(createHabitVC, animated: true)
    }
    @objc func buttonTouchedDown(sender: UIButton!) {
        sender.backgroundColor = .customGreen.darker()
    }
    @objc func buttonTouchedUp(sender: UIButton!) {
        sender.backgroundColor = .customGreen
    }

    var presenter: HabitPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter = HabitPresenter(view: self, habitManager: HabitManager.shared)

        habitTableView.delegate = self
        habitTableView.dataSource = self

        habitTableView.register(HabitCell.self, forCellReuseIdentifier: HabitCell.identifier)

        view.backgroundColor = .white

        view.addSubview(helloLabel)
        view.addSubview(progressView)
        view.addSubview(habitTableView)
        view.addSubview(addHabitButton)
        addHabitButton.addSubview(plusLabel)

        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        habitTableView.reloadData()
        progressView.updateView()
    }

    private func setupConstraints() {
        helloLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(-25)
            make.left.right.equalToSuperview().inset(30)
        }

        progressView.snp.makeConstraints { make in
            make.top.equalTo(helloLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(200)
        }

        habitTableView.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }

        addHabitButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(30)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.width.height.equalTo(60)
        }

        plusLabel.snp.makeConstraints { make in
            make.centerY.equalTo(addHabitButton.snp.centerY).offset(-3)
            make.centerX.equalTo(addHabitButton.snp.centerX)
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let presenter = presenter else { return 0 }
        return presenter.getHabits().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HabitCell.identifier, for: indexPath) as! HabitCell
        guard let presenter = presenter else { return cell }
        guard let habit = presenter.getHabit(at: indexPath.row) else { return cell }
        cell.configure(with: habit)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let habit = presenter?.getHabit(at: indexPath.row) else { return }

        let alertController = UIAlertController(title: "What is your progress", message: nil, preferredStyle: .alert)

        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Progress"
            textField.text = String(habit.progress)
            textField.keyboardType = .numberPad
        }

        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self, weak tableView] alert -> Void in
            let textField = alertController.textFields![0] as UITextField
            let progress = Int(textField.text ?? "") ?? 0
            self?.presenter?.updateProgressHabit(at: indexPath.row, with: progress)
            tableView?.reloadData()
            self?.progressView.updateView()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (action : UIAlertAction!) -> Void in })

        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            tableView.beginUpdates()
            self.presenter?.deleteHabit(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }

        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            guard let habit = self.presenter?.getHabit(at: indexPath.row) else { return }

            let createHabitVC = CreateHabitViewController(presenter: self.presenter, habitToEdit: habit)
            self.navigationController?.pushViewController(createHabitVC, animated: true)
        }

        return [deleteAction, editAction]
    }
}
