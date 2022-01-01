import Foundation

@testable import DogsChallenge

enum LocalJsonFiles: String {
    case breeds = "BreedsResponse"
    case breedsByName = "BreedsByNameResponse"
}

class JsonHelper {
    
    static func getData(fromFile name: LocalJsonFiles) -> Data {
        
        let bundle = Bundle(for: self)
        guard let path = bundle.path(forResource: name.rawValue, ofType: "json") else {
            fatalError("The resource named: \(name).json was not found!")
        }
        
        do {
            let url = URL(fileURLWithPath: path)
            guard let data = try? Data(contentsOf: url, options: .mappedIfSafe) else {
                fatalError("Fail getting data information from \(url)")
            }
            return data
        }
        
    }
    
}
