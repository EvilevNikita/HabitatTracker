//
//  CreateHabitViewController.swift
//  HabitatTracker
//
//  Created by Nikita Ivlev on 21/5/23.
//

import SnapKit
import UIKit

class CreateHabitViewController: UIViewController {
    var presenter: HabitPresenterProtocol?
    var habitToEdit: Habit?
    let habitManager = HabitManager.shared

    var habitNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Название привычки"
        textField.borderStyle = .roundedRect
        return textField
    }()

    var goalTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите цель"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()

    var startDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.tintColor = .lightOrange
        datePicker.datePickerMode = .date
        return datePicker
    }()

    var startDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Дата начала"
        return label
    }()

    var endDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.tintColor = .lightOrange
        datePicker.datePickerMode = .date
        return datePicker
    }()

    var endDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Дата конца"
        return label
    }()

    var frequencySegmentedControl: UISegmentedControl = {
        let items = ["Ежедневно", "Еженедельно", "Ежемесячно"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        let font = UIFont.systemFont(ofSize: 14)
        segmentedControl.setTitleTextAttributes([.font: font], for: .normal)
        segmentedControl.selectedSegmentTintColor = .lightOrange
        return segmentedControl
    }()

    var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .customGreen
        button.layer.cornerRadius = 30
        return button
    }()

    init(presenter: HabitPresenterProtocol?, habitToEdit: Habit?) {
        self.presenter = presenter
        self.habitToEdit = habitToEdit
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = UIColor.orange

        view.addSubview(habitNameTextField)
        view.addSubview(goalTextField)
        view.addSubview(startDateLabel)
        view.addSubview(endDateLabel)
        view.addSubview(startDatePicker)
        view.addSubview(endDatePicker)
        view.addSubview(frequencySegmentedControl)
        view.addSubview(saveButton)

        if let habit = habitToEdit {
            habitNameTextField.text = habit.name
            goalTextField.text = String(habit.goal)
            startDatePicker.date = habit.start ?? Date()
            endDatePicker.date = habit.finish ?? Date()
            frequencySegmentedControl.selectedSegmentIndex = Frequency.allCases.firstIndex(of: habit.frequency) ?? 0
            saveButton.setTitle("Save", for: .normal)
        }

        setupConstraints()

        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        view.bringSubviewToFront(saveButton)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func saveButtonTapped() {
        guard let habitName = habitNameTextField.text, !habitName.isEmpty else {
            showAlertWith(message: "Please enter a habit name")
            return
        }

        guard let goalValueText = goalTextField.text, let goalValue = Int(goalValueText), goalValue > 0 else {
            showAlertWith(message: "Goal cannot be zero")
            return
        }

        let startDate = startDatePicker.date
        let endDate = endDatePicker.date
        let frequency = Frequency(rawValue: frequencySegmentedControl.titleForSegment(at: frequencySegmentedControl.selectedSegmentIndex) ?? "") ?? .daily

        if let habit = habitToEdit {
            if let index = habitManager.getHabits().firstIndex(where: { $0.id == habit.id }) {
                presenter?.updateHabitDetails(at: index, name: habitName, goal: goalValue, startDate: startDate, endDate: endDate, frequency: frequency)
            }
        } else {
            presenter?.saveHabit(name: habitName, goal: goalValue, startDate: startDate, endDate: endDate, frequency: frequency)
        }

        navigationController?.popViewController(animated: true)
    }

    func showAlertWith(message: String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }

    private func setupConstraints() {
        habitNameTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(40)
        }

        goalTextField.snp.makeConstraints { make in
            make.top.equalTo(habitNameTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(40)
        }

        startDateLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(30)
            make.centerY.equalTo(startDatePicker.snp.centerY)
        }

        endDateLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(30)
            make.centerY.equalTo(endDatePicker.snp.centerY)
        }


        startDatePicker.snp.makeConstraints { make in
            make.top.equalTo(goalTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(30)
        }

        endDatePicker.snp.makeConstraints { make in
            make.top.equalTo(startDatePicker.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(30)
        }

        frequencySegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(endDatePicker.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(30)
        }

        saveButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(50)
            make.height.equalTo(60)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
    }
}
