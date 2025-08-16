//
//  View+.swift
//  SaiSai
//
//  Created by ch on 8/16/25.
//

import UIKit
import SwiftUI

extension View {
    func endTextEditing() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}
