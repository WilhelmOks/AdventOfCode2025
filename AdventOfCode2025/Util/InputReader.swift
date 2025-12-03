//
//  InputReader.swift
//  AdventOfCode2025
//
//  Created by Wilhelm Oks on 01.12.25.
//

import Foundation

func readInput(day: String, trim: Bool = true) -> String {
    let fileName = "input\(day)"
    guard let fileURL = Bundle.main.path(forResource: fileName, ofType: "txt") else { return "" }
    guard let url = URL(string: "file://"+fileURL) else { return "" }
    guard let inputData = try? Data(contentsOf: url) else { return "" }
    let text = String(data: inputData, encoding: .utf8) ?? ""
    if trim {
        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    } else {
        return text
    }
}
