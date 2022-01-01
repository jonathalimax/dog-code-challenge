import Foundation

public enum Environment {
    
    case baseUrl
    case apiKey
    
    var value: String {
        switch self {
        case .baseUrl:
            return getInfoDictionaryValue(for: "BASE_URL")
        case .apiKey:
            return getInfoDictionaryValue(for: "API_KEY")
        }
    }
    
}

extension Environment {

    private var infoDictionary: [String: AnyObject]? {
        Bundle.main.infoDictionary?["LSEnvironment"] as? [String: AnyObject]
    }
    
    private func getInfoDictionaryValue(for key: String) -> String {
        infoDictionary?[key] as? String ?? ""
    }
    
}
