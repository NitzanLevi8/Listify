import SwiftUI
import UIKit

struct NavigationTitleFont: ViewModifier {
    init(name: String, size: CGFloat) {
        let attributes:[NSAttributedString.Key : Any]? = [.font: UIFont(name: name, size: size) ?? .systemFont(ofSize: 18)]
        let small:[NSAttributedString.Key : Any]? = [.font: UIFont(name: name, size: 18) ?? .systemFont(ofSize: 18), .foregroundColor: UIColor.tintColor]
        UINavigationBar.appearance().largeTitleTextAttributes = attributes
        UINavigationBar.appearance().titleTextAttributes = [.font: UIFont(name: name, size: 18) ?? .systemFont(ofSize: 18)]
        UIBarButtonItem.appearance().setTitleTextAttributes(small, for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes(small, for: .highlighted)
    }
    
    func body(content: Content) -> some View {
        content
    }
}

struct TabViewFont: ViewModifier {
    init(name: String, size: CGFloat){
        let attrs:[NSAttributedString.Key : Any]? = [.font: UIFont(name: name, size: size) ?? .systemFont(ofSize: 18)]
        let highlighted:[NSAttributedString.Key : Any]? = [.font: UIFont(name: name, size: size) ?? .systemFont(ofSize: 18), .foregroundColor: UIColor.tintColor]
        UITabBarItem.appearance().setTitleTextAttributes(attrs, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(highlighted, for: .highlighted)
    }
    
    func body(content: Content) -> some View {
        content
    }
}

extension View {
    func navigationTitleFont(name: String, size: CGFloat) -> some View {
        self.modifier(NavigationTitleFont(name: name, size: size))
    }
    
    func tabsFont(name: String, size: CGFloat)-> some View{
        self.modifier(TabViewFont(name: name, size: size))
    }
}

extension Font {
    public static var sofiaMedium: Font {
        return Font.custom("SofiaPro-Medium", size: 18)
    }
    
    public static func sofia ()->Font{
        return Font.custom("SofiaPro", size: 18)
    }
    
    public static func sofia (_ size: CGFloat)->Font{
        return Font.custom("SofiaPro", size: size)
    }
    public static func sofia (_ size: CGFloat?, _ weight: Weight?)->Font{
        return Font.custom("SofiaPro", size: size ?? 18).weight(weight ?? .regular)
    }
}
