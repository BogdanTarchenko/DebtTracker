import UIKit

extension UIColor {
    enum App {
        static var black: UIColor {
            UIColor(
                named: "BlackCustomColor"
            ) ?? .black
        }

        static var white: UIColor {
            UIColor(
                named: "WhiteCustomColor"
            ) ?? .white
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

        static var orange: UIColor {
            UIColor(
                named: "OrangeCustomColor"
            ) ?? .orange
        }

        static var purple: UIColor {
            UIColor(
                named: "PurpleCustomColor"
            ) ?? .systemPurple
        }

        static var gray: UIColor {
            UIColor(
                named: "GrayCustomColor"
            ) ?? .systemGray6
        }

        static var red: UIColor {
            UIColor(
                named: "RedCustomColor"
            ) ?? .systemRed
        }
    }
}
