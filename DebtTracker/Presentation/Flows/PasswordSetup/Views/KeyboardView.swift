import UIKit

// MARK: - KeyboardViewDelegate

@MainActor
protocol KeyboardViewDelegate: AnyObject {
    func keyPressed(_ key: String)
}

// MARK: - KeyboardView

final class KeyboardView: UIView {
    // MARK: - Properties

    weak var delegate: KeyboardViewDelegate?

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    // MARK: - Setup

    private func setupView() {
        backgroundColor = .black
        layer.cornerRadius = Constants.cornerRadius

        let gridStack = UIStackView()
        gridStack.axis = .vertical
        gridStack.distribution = .fillEqually
        gridStack.spacing = Constants.gridSpacing
        addSubview(gridStack)

        gridStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        setupKeyboardRows(in: gridStack)
    }

    private func setupKeyboardRows(in stack: UIStackView) {
        let buttonTitles = [
            ["1", "2", "3"],
            ["4", "5", "6"],
            ["7", "8", "9"],
            ["", "0", "⌫"]
        ]

        for row in buttonTitles {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.distribution = .fillEqually
            rowStack.spacing = Constants.rowSpacing
            stack.addArrangedSubview(rowStack)

            for title in row {
                createButton(with: title, in: rowStack)
            }
        }
    }

    private func createButton(with title: String, in stack: UIStackView) {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(
            ofSize: Constants.keyboardButtonFontSize,
            weight: .medium
        )
        button.backgroundColor = .black
        button.setTitleColor(UIColor.App.white, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        stack.addArrangedSubview(button)
    }

    // MARK: - Actions

    @objc private func buttonTapped(_ sender: UIButton) {
        guard let key = sender.titleLabel?.text else { return }
        delegate?.keyPressed(key)
    }

    // MARK: - Constants

    private enum Constants {
        static let keyboardButtonFontSize: CGFloat = 32
        static let cornerRadius: CGFloat = 10
        static let gridSpacing: CGFloat = 1
        static let rowSpacing: CGFloat = 1
    }
}
