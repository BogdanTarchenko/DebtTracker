import LocalAuthentication

// MARK: - BiometricError

enum BiometricError: Error {
    case notAvailable
    case notEnrolled
    case lockedOut
    case cancelled
    case unknown(Error)

    var localizedDescription: String {
        switch self {
        case .notAvailable:
            "Биометрия недоступна"
        case .notEnrolled:
            "Face ID не настроен. Пожалуйста, добавьте лицо в настройках устройства"
        case .lockedOut:
            "Face ID заблокирован. Введите пароль устройства"
        case .cancelled:
            "Аутентификация отменена"
        case let .unknown(error):
            error.localizedDescription
        }
    }
}

// MARK: - BiometricService

final class BiometricService {
    private let context = LAContext()

    var biometryType: LABiometryType {
        var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
            ? context.biometryType
            : .none
    }

    var isFaceIDAvailable: Bool {
        biometryType == .faceID
    }

    func authenticate(reason: String = "Аутентификация") async -> Result<Void, BiometricError> {
        var error: NSError?

        guard context
            .canEvaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                error: &error
            )
        else {
            if let laError = error as? LAError {
                switch laError.code {
                case .biometryNotAvailable:
                    return .failure(.notAvailable)
                case .biometryNotEnrolled:
                    return .failure(.notEnrolled)
                case .biometryLockout:
                    return .failure(.lockedOut)
                default:
                    return .failure(.unknown(laError))
                }
            }
            return .failure(.notAvailable)
        }

        do {
            let success = try await context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: reason
            )
            return success ? .success(()) : .failure(.cancelled)
        } catch let error as LAError where error.code == .userCancel {
            return .failure(.cancelled)
        } catch {
            return .failure(.unknown(error))
        }
    }
}
