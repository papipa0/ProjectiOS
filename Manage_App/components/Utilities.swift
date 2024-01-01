//

import Foundation
import UIKit

final class Utilities{
    
    static let shared = Utilities()
    private init() {}
    
    func topViweController(controller: UIViewController? = nil )-> UIViewController?{
        
        let controller = controller ?? UIApplication.shared.keyWindow?.rootViewController
        
        if let navigationController = controller as? UINavigationController{
            return topViweController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController{
            if let selected = tabController.selectedViewController{
                return topViweController(controller: selected)
            }
        }
        if let presented = controller?.presentingViewController{
            return topViweController(controller: presented)
        }
        return controller
    }
}
