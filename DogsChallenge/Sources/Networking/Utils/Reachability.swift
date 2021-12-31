import Alamofire

struct Reachability {
    
    let manager = NetworkReachabilityManager(host: "google.com.br")
    
    func start() {
        manager?.startListening(onUpdatePerforming: { _ in })
    }
    
    func isReachable() -> Bool {
        guard let manager = manager else {
            return false
        }
        
        return manager.isReachable
    }
    
}
