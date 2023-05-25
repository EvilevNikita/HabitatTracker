//
//  ProgressiveView.swift
//  HabitatTracker
//
//  Created by Nikita Ivlev on 20/5/23.
//

import UIKit
import SnapKit

class GradientBackgroundView: UIView {
    private var gradientLayer: CAGradientLayer!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.bounds
    }

    private func setupGradient() {
        gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.darkOrange.cgColor, UIColor.lightOrange.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}

final class ProgressView: GradientBackgroundView {

    let progressBar: CircularProgressBar = {
        let progressBar = CircularProgressBar()
        return progressBar
    }()

    let percentageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 32)
        return label
    }()

    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        label.text = dateFormatter.string(from: Date())
        label.font = UIFont.systemFont(ofSize: 14, weight: .black)
        return label
    }()

    let taskCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        addSubview(progressBar)
        addSubview(percentageLabel)
        addSubview(dateLabel)
        addSubview(taskCountLabel)

        progressBar.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(35)
            make.height.width.equalTo(100)
        }

        percentageLabel.snp.makeConstraints { make in
            make.center.equalTo(progressBar.snp.center)
        }

        taskCountLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(progressBar.snp.right).offset(35)
        }

        dateLabel.snp.makeConstraints { make in
            make.bottom.equalTo(taskCountLabel.snp.top).offset(-10)
            make.left.equalTo(progressBar.snp.right).offset(35)
        }
    }

    func updateView() {
        let habitManager = HabitManager.shared
        let totalProgress = habitManager.getTotalProgress()
        let finishedHabits = habitManager.getFinishedHabits().count
        let habits = habitManager.getHabits().count

        CATransaction.begin()
        CATransaction.setDisableActions(true)
        progressBar.progress = totalProgress
        CATransaction.commit()

        if habits == 0 {
            percentageLabel.text = "0%"
        } else {
            percentageLabel.text = "\(Int(totalProgress * 100))%"
        }

        if habits == 0 {
            taskCountLabel.text = "Add your first habit"
        } else {
            taskCountLabel.text = "\(finishedHabits) of \(habits) habits \n completed today!"
        }
    }
}
