//
//  Flavor.swift
//  Runner
//
// 参考:https://medium.com/flutter-jp/flavor-b952f2d05b5d

import Foundation

enum Flavor: String, CaseIterable {
    case development, production

    static let current: Flavor = {
        let value = Bundle.main.infoDictionary?["FlutterFlavor"]
        let flavor = Flavor(rawValue: (value as? String)?.lowercased() ?? "")
        assert(flavor != nil, "invalid flavor value: \(value ?? "")")
        return flavor ?? .development
    }()
}
