////
////  CircularProgressBar.swift
////  HabitatTracker
////
////  Created by Nikita Ivlev on 20/5/23.
////
//

import UIKit

final class CircularProgressBar: UIView {

    private var backgroundLayer: CAShapeLayer!
    private var progressLayer: CAShapeLayer!
    var progress: CGFloat = 0 {
        didSet {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            progressLayer?.strokeEnd = progress
            CATransaction.commit()
        }
    }

    var backgroundLineWidth: CGFloat = 10.0 {
        didSet {
            backgroundLayer?.lineWidth = backgroundLineWidth
            updatePath()
        }
    }

    var progressLineWidth: CGFloat = 10.0 {
        didSet {
            progressLayer?.lineWidth = progressLineWidth
            updatePath()
        }
    }

    var progressColor: UIColor = UIColor.white {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.progressLayer?.strokeColor = self?.progressColor.cgColor
            }
        }
    }

    var backgroundProgressColor: UIColor = UIColor.white {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.backgroundLayer?.strokeColor = self?.backgroundProgressColor.cgColor
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        createCircularPath()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createCircularPath()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updatePath()
    }

    private func createCircularPath() {
        backgroundLayer = CAShapeLayer()
        backgroundLayer.lineCap = .round
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.lineWidth = backgroundLineWidth
        layer.addSublayer(backgroundLayer)

        progressLayer = CAShapeLayer()
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.opacity = 1
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.lineWidth = progressLineWidth
        layer.addSublayer(progressLayer)
    }

    private func updatePath() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: frame.size.width / 2, startAngle: -.pi / 2, endAngle: 3 * .pi / 2, clockwise: true)

        backgroundLayer.path = circularPath.cgPath
        backgroundLayer.strokeColor = backgroundProgressColor.withAlphaComponent(0.2).cgColor

        progressLayer.path = circularPath.cgPath
        progressLayer.strokeEnd = progress
    }
}
