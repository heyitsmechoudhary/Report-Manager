//
//  PDFDocument.swift
//  Report Manager
//
//  Created by Rahul choudhary on 21/06/25.
//

import Foundation

struct PDFDocument: Identifiable {
    let id = UUID()
    let url: String
    let name: String
    let size: Int64?
    var localPath: String?
}
