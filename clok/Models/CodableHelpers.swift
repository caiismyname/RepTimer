//
//  CodableHelpers.swift
//  Clok
//
//  Created by David Cai on 2/3/23.
//

import SwiftUI

func CodableFileURLGenerator(dataFileName: String) -> URL {
    if let docURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.clok") {
        print("got the shared container")
        return docURL.appendingPathComponent(dataFileName)
    } else {
        print("not shared container")
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docURL = paths[0]
        return docURL.appendingPathComponent(dataFileName)
    }
}
