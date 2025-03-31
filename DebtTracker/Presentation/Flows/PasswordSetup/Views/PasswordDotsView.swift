import SnapKit
import UIKit

// MARK: - PasswordDotsView

final class PasswordDotsView: UIView {
    private let stackView = UIStackView()
    private var dotViews: [UIView] = []

    var filledDotsCount: Int = 0 {
        didSet { updateDots() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        createDots()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(stackView)
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = Constants.dotsSpacing

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func createDots() {
        dotViews.forEach { $0.removeFromSuperview() }
        dotViews.removeAll()

        for _ in 0 ..< 4 {
            let dot = UIView()
            dot.backgroundColor = UIColor.App.gray
            dot.layer.cornerRadius = Constants.dotSize / 2
            dot.snp.makeConstraints { make in
                make.width.height.equalTo(Constants.dotSize)
            }
            dotViews.append(dot)
            stackView.addArrangedSubview(dot)
        }
    }

    func updateDots() {
        for (index, dot) in dotViews.enumerated() {
            dot.backgroundColor = index < filledDotsCount ? UIColor.App.purple : UIColor.App.gray
        }
    }

    func highlight(with color: UIColor, duration: TimeInterval = Constants.animationDuration) {
        let animationBlock = {
            self.dotViews.forEach { $0.backgroundColor = color }
        }

        if duration > 0 {
            UIView
                .animate(
                    withDuration: duration,
                    animations: animationBlock
                )
        } else {
            animationBlock()
        }
    }

    func reset() {
        filledDotsCount = 0
        dotViews.forEach { $0.backgroundColor = UIColor.App.gray }
    }
}

// MARK: PasswordDotsView.Constants

extension PasswordDotsView {
    private enum Constants {
        static let dotSize: CGFloat = 20
        static let dotsSpacing: CGFloat = 20
        static let animationDuration: TimeInterval = 0.2
    }
}
