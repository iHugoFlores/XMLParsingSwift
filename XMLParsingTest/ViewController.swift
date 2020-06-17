//
//  ViewController.swift
//  XMLParsingTest
//
//  Created by Hugo Flores Perez on 6/17/20.
//  Copyright © 2020 Hugo Flores Perez. All rights reserved.
//

import UIKit

struct Book {
    var bookTitle: String
    var bookAuthor: String
}

struct Part {
    var name: String
    var type: String
}

class ViewController: UITableViewController {
    
    var books: [Book] = []
    var elementName: String = String()
    var bookTitle = String()
    var bookAuthor = String()

    var parts: [Part] = []
    var partName = String()
    var partType = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadXMLFile()
    }
    
    func loadXMLFile() {
        if let path = Bundle.main.url(forResource: "part_pv", withExtension: "xml") {
            if let parser = XMLParser(contentsOf: path) {
                parser.delegate = self
                parser.parse()
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return parts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            
        // let book = books[indexPath.row]
        let part = parts[indexPath.row]
            
        cell.textLabel?.text = part.name
        cell.detailTextLabel?.text = part.type

        return cell
    }
}

extension ViewController: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "T" {
            partName = String()
            partType = String()
        }
        self.elementName = elementName
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "T" {
            let part = Part(name: partName, type: partType)
            parts.append(part)
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if (!data.isEmpty) {
            if self.elementName == "P_NAME" {
                partName += data
            } else if self.elementName == "P_TYPE" {
                partType += data
            }
        }
    }
}

//extension ViewController: XMLParserDelegate {
//    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
//        if elementName == "book" {
//            bookTitle = String()
//            bookAuthor = String()
//        }
//        self.elementName = elementName
//    }
//
//    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
//        if elementName == "book" {
//            let book = Book(bookTitle: bookTitle, bookAuthor: bookAuthor)
//            books.append(book)
//        }
//    }
//
//    func parser(_ parser: XMLParser, foundCharacters string: String) {
//        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
//        if (!data.isEmpty) {
//            if self.elementName == "title" {
//                bookTitle += data
//            } else if self.elementName == "author" {
//                bookAuthor += data
//            }
//        }
//    }
//}
