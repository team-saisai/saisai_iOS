//
//  TermsWebView.swift
//  SaiSai
//
//  Created by ch on 8/20/25.
//

import SwiftUI
import SafariServices

struct TermsWebView: UIViewControllerRepresentable {

    let url: String = "https://www.notion.so/ihayeong/2471c81f481d8092b7c5e2dfe57bc681"
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<TermsWebView>) -> SFSafariViewController {
        return SFSafariViewController(url: URL(string: url)!)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<TermsWebView>) {
        
    }
}
