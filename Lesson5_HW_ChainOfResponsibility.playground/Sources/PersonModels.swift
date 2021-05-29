import Foundation



public struct DataPerson: Decodable {
    public let data: [Person]
}

public struct ResultPerson: Decodable {
    public let result: [Person]
}

public struct Person: Decodable {
    public let name: String
    public let age: Int
    public let isDeveloper: Bool
}
