//
//  Extensions.swift
//  List People
//
//  Created by Engin Yildiz on 4.10.2021.
//

import UIKit

extension UIApplication {
    
    var keyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)
    }
    
    var keyWindowPresentedController: UIViewController? {
        return self.keyWindow?.rootViewController
    }
}

extension Array {
    
    func uniques<T: Hashable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        return reduce([]) { result, element in
            let alreadyExists = (result.contains(where: { $0[keyPath: keyPath] == element[keyPath: keyPath] }))
            
            if alreadyExists {
                print("Duplicate found: ", (element as! Person).id, (element as! Person).fullName)
            }
            
            return alreadyExists ? result : result + [element]
        }
    }
}
