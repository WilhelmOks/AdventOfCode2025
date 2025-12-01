//
//  InputReader.swift
//  AdventOfCode2025
//
//  Created by Wilhelm Oks on 01.12.25.
//

import Foundation

func readInput(day: String) -> String {
    let fileName = "input\(day)"
    guard let fileURL = Bundle.main.path(forResource: fileName, ofType: "txt") else { return "" }
    guard let url = URL(string: "file://"+fileURL) else { return "" }
    guard let inputData = try? Data(contentsOf: url) else { return "" }
    return String(data: inputData, encoding: .utf8) ?? ""
}
