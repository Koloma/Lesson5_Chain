import UIKit

func data(from file: String) -> Data {
    let path1 = Bundle.main.path(forResource: file, ofType: "json")!
    let url = URL(fileURLWithPath: path1)
    let data = try! Data(contentsOf: url)
    return data
}

protocol PersonParser{
    var next: PersonParser? { get set }
    func parse(_ data: Data) -> [Person]?
}


let data1 = data(from: "1")
let data2 = data(from: "2")
let data3 = data(from: "3")
let dataEmpty = Data()

let arrData = [data1,data2,data3,dataEmpty]

class DataPersonParser: PersonParser{
    var next: PersonParser?
    
    func parse(_ data: Data) -> [Person]? {
        do{
            let decoder = JSONDecoder()
            let person = try decoder.decode(DataPerson.self, from: data)
            print("DataPersonParser")
            return person.data
         }
        catch{
            return self.next?.parse(data)
        }
        
    }
}

class ResultPersonParser: PersonParser{
    var next: PersonParser?
    
    func parse(_ data: Data) -> [Person]? {
        do{
            let decoder = JSONDecoder()
            let person = try decoder.decode(ResultPerson.self, from: data)
            print("ResultPersonParser")
            return person.result
         }
        catch{
            return self.next?.parse(data)
        }
        
    }
}

class ClearPersonParser: PersonParser{
    var next: PersonParser?
    
    func parse(_ data: Data) -> [Person]? {
        do{
            let decoder = JSONDecoder()
            let person = try decoder.decode([Person].self, from: data)
            print("ClearPersonParser")
            return person
         }
        catch{
            return self.next?.parse(data)
        }
        
    }
}

let dataPersonParser = DataPersonParser()
let resultPersonParser = ResultPersonParser()
let clearPersonParser = ClearPersonParser()
let personParser: PersonParser = dataPersonParser

dataPersonParser.next = resultPersonParser
resultPersonParser.next = clearPersonParser
clearPersonParser.next = nil

for (index,data) in arrData.enumerated() {
    if let persons = personParser.parse(data){
        print("Person data index \(index)")
        persons.forEach{ print($0.name,$0.age) }
    }else{
        print("Person data \(index) is Empty")
    }
}



