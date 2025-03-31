import UIKit

// MARK: - KeyboardViewDelegate

@MainActor
protocol KeyboardViewDelegate: AnyObject {
    func keyPressed(_ key: String)
    func faceIDTapped()
}

// MARK: - KeyboardView

final class KeyboardView: UIView {
    // MARK: - Properties

    weak var delegate: KeyboardViewDelegate?

    // MARK: - UI Components

    private lazy var faceIDContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.addSubview(faceIDButton)
        faceIDButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return view
    }()

    private lazy var faceIDButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(
            pointSize: Constants.keyboardButtonFontSize,
            weight: .medium
        )
        button.setImage(UIImage(systemName: "faceid", withConfiguration: config), for: .normal)
        button.tintColor = UIColor.App.white
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(faceIDTapped), for: .touchUpInside)
        button.isHidden = true
        return button
    }()

    var isFaceIDEnabled: Bool = false {
        didSet {
            faceIDButton.isHidden = !isFaceIDEnabled
        }
    }

    // MARK: - Initialization

    init(frame: CGRect, isFaceIDEnabled: Bool) {
        super.init(frame: frame)
        setupView()
        faceIDButton.isHidden = !isFaceIDEnabled
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
            ["faceid", "0", "⌫"]
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
        guard !title.isEmpty else {
            let emptyView = UIView()
            emptyView.backgroundColor = .black
            stack.addArrangedSubview(emptyView)
            return
        }

        if title != "faceid" {
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
        } else {
            stack.addArrangedSubview(faceIDContainer)
        }
    }

    // MARK: - Actions

    @objc private func buttonTapped(_ sender: UIButton) {
        guard let key = sender.titleLabel?.text else { return }
        delegate?.keyPressed(key)
    }

    @objc private func faceIDTapped() {
        delegate?.faceIDTapped()
    }

    // MARK: - Constants

    private enum Constants {
        static let keyboardButtonFontSize: CGFloat = 32
        static let faceIDIconSize: CGFloat = 28
        static let cornerRadius: CGFloat = 10
        static let gridSpacing: CGFloat = 1
        static let rowSpacing: CGFloat = 1
    }
}
