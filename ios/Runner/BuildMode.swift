//
//  BuildMode.swift
//  Runner
//
// 参考:https://medium.com/flutter-jp/flavor-b952f2d05b5d

import Foundation

enum BuildMode: CaseIterable {
    case debug, release

    #if DEBUG
    static let current = BuildMode.debug
    #else
    static let current = BuildMode.release
    #endif
}
