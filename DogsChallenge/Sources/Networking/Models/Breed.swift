struct Breed: Codable, Hashable {
    
    let id: Int
    let name: String
    let origin: String?
    let bredFor: String?
    let breedGroup: String?
    let temperament: String?
    let lifeSpan: String?
    let height: Eight?
    let weight: Eight?
    let image: Image?
    let referenceImageID: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case origin
        case bredFor = "bred_for"
        case breedGroup = "breed_group"
        case temperament
        case lifeSpan = "life_span"
        case height
        case weight
        case image
        case referenceImageID = "reference_image_id"
    }
 
    struct Eight: Codable, Hashable {
        let imperial: String
        let metric: String
    }

    struct Image: Codable, Hashable {
        let id: String
        let url: String
        let width: Int
        let height: Int
    }
    
}
