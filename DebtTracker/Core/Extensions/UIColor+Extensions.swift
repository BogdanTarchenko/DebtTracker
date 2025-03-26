import UIKit

extension UIColor {
    enum App {
        static var black: UIColor {
            UIColor(
                named: "BlackCustomColor"
            ) ?? .black
        }

        static var blue: UIColor {
            UIColor(
                named: "BlueCustomColor"
            ) ?? .systemBlue
        }

        static var green: UIColor {
            UIColor(
                named: "GreenCustomColor"
            ) ?? .systemGreen
        }

        static var lightBlue: UIColor {
            UIColor(
                named: "LightBlueCustomColor"
            ) ?? .systemTeal
        }

        static var pink: UIColor {
            UIColor(
                named: "PinkCustomColor"
            ) ?? .systemPink
        }

        static var red: UIColor {
            UIColor(
                named: "RedCustomColor"
            ) ?? .systemRed
        }

        static var tabBar: UIColor {
            UIColor(
                named: "TabBarColor"
            ) ?? .white
        }

        static var tabBarItemActive: UIColor {
            UIColor(
                named: "TabBarItemActiveColor"
            ) ?? .systemBlue
        }

        static var tabBarItemInactive: UIColor {
            UIColor(
                named: "TabBarItemInactiveColor"
            ) ?? .systemGray
        }

        static var yellow: UIColor {
            UIColor(
                named: "YellowCustomColor"
            ) ?? .systemYellow
        }
    }
}
