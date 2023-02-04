//
//  CodableHelpers.swift
//  Clok
//
//  Created by David Cai on 2/3/23.
//

import SwiftUI

func CodableFileURLGenerator(dataFileName: String) -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let docURL = paths[0]
    return docURL.appendingPathComponent(dataFileName)
}
