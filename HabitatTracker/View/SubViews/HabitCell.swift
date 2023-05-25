//
//  UITableViewCell.swift
//  HabitatTracker
//
//  Created by Nikita Ivlev on 20/5/23.
//

import SnapKit
import UIKit

final class HabitCell: UITableViewCell {
    static let identifier = "HabitCell"

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()

    let progressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        return label
    }()

    let circularProgressBar: CircularProgressBar = {
        let progressBar = CircularProgressBar()
        return progressBar
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(nameLabel)
        contentView.addSubview(progressLabel)
        contentView.addSubview(circularProgressBar)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
        }

        progressLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(10)
        }

        circularProgressBar.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.width.height.equalTo(30)
        }
    }

    func configure(with habit: Habit) {
        nameLabel.text = habit.name
        progressLabel.text = "\(habit.progress) / \(habit.goal)"
        circularProgressBar.progress = CGFloat(habit.progress) / CGFloat(habit.goal)
        circularProgressBar.backgroundLineWidth = 4.0
        circularProgressBar.progressLineWidth = 4.0
        circularProgressBar.progressColor = .customGreen
        circularProgressBar.backgroundProgressColor = .customGreen.withAlphaComponent(0.2)
        if habit.isFinished {
            contentView.backgroundColor = .customGreen.withAlphaComponent(0.1)
            nameLabel.textColor = .customGreen
            progressLabel.textColor = .customGreen
        } else {
            contentView.backgroundColor = .white
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        nameLabel.text = nil
        progressLabel.text = nil
        circularProgressBar.progress = 0
        circularProgressBar.progressColor = .customGreen
        circularProgressBar.backgroundProgressColor = .customGreen.withAlphaComponent(0.2)
        circularProgressBar.backgroundLineWidth = 4.0
        circularProgressBar.progressLineWidth = 4.0
        contentView.backgroundColor = .clear
        nameLabel.textColor = .black
        progressLabel.textColor = .black
    }
}
