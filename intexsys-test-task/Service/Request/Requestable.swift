//
//  Requestable.swift
//  intexsys-test-task
//
//  Created by Vladislav Khomyakov on 01.07.2022.
//

import Foundation

protocol Requestable {
    var urlRequest: URLRequest { get }
    var decoder: JSONDecoder { get }
}
