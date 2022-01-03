import UIKit

extension UIViewController {
    
    var currentState: ViewState? {
        let currentStateView = view.subviews
            .filter{ $0 is StateView }.first as? StateView
        
        return currentStateView?.state
    }
 
    func setState(_ state: ViewState) {
        let currentStateView = view.subviews
            .filter{ $0 is StateView }.first as? StateView
        
        let stateView = currentStateView ?? StateView(state)
        
        if currentStateView == nil {
            self.view.addSubview(stateView)
            
            NSLayoutConstraint.activate([
                stateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                stateView.topAnchor.constraint(equalTo: view.topAnchor),
                stateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                stateView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
            
        }
        
        switch state {
        case .loading, .error, .empty:
            stateView.updateState(state)
        case .success:
            stateView.removeFromSuperview()
        }
        
    }
    
}
