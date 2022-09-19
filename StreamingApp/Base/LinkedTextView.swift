//
//  LinkedTextView.swift
//  StreamingApp
//
//  Created by Andriy Briznichenko on 7/4/22.
//

import Foundation
import UIKit
import simd

final class LinkedTextView: UITextView {
    let baseText: String
    let fontSize: CGFloat
    let letterSpacing: CGFloat
    let links: [String: URL?]
    
    init(baseText: String, fontSize: CGFloat, letterSpacing: CGFloat, links: [String: URL?]) {
        self.baseText = baseText
        self.fontSize = fontSize
        self.letterSpacing = letterSpacing
        self.links = links
        
        super.init(frame: .zero, textContainer: nil)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Should use designated init(baseText:..) of class LinkedTextView")
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        fatalError("Should use designated init(baseText:..) of class LinkedTextView")
    }
    
    private func setupView() {
        backgroundColor = .black
        
        let boldFont = FontFamily.ProximaNova.bold.font(size: fontSize)
        let regularFont = FontFamily.ProximaNova.regular.font(size: fontSize)
        let attributedString = NSMutableAttributedString(string: baseText, attributes: [
            .font: regularFont,
            .kern: letterSpacing
        ])
        attributedString.addAttribute(.foregroundColor,
                                      value: Asset.Colors.streamingLightGray.color,
                                      range: NSMakeRange(0, attributedString.length))
        for (string, url) in links {
            if let url = url {
                attributedString.addAttribute(.link, value: url, range: attributedString.mutableString.range(of: string))
            }
            attributedString.addAttribute(.font, value: boldFont, range: attributedString.mutableString.range(of: string))
        }
        
        textContainerInset = .zero
        attributedText = attributedString
        isEditable = false
        isSelectable = true
        isScrollEnabled = false
        delegate = self
        
        linkTextAttributes = [:]
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        toggleLinkHighlighted(at: touches.first?.location(in: self), highlighted: true)
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        toggleLinkHighlighted(at: touches.first?.location(in: self), highlighted: false)
        super.touchesEnded(touches, with: event)
    }
    
    private func toggleLinkHighlighted(at point: CGPoint?, highlighted: Bool) {
        guard let location = point else { return }
        let index = layoutManager.characterIndex(for: location, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        let selectedLinkRange = attributedText.findLinkRange(at: index)

        if let range = selectedLinkRange {
            toggleLinkHighlighted(at: range, highlighted: highlighted)
        }
    }
    
    private func toggleLinkHighlighted(at range: NSRange, highlighted: Bool) {
        let mutableText = NSMutableAttributedString(attributedString: attributedText)
        mutableText.setColor(highlighted ? .white : Asset.Colors.streamingLightGray.color, at: range)
        attributedText = mutableText
    }
}

extension LinkedTextView: UITextViewDelegate {
    func textViewDidChangeSelection(_ textView: UITextView) {
        textView.selectedTextRange = nil
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        toggleLinkHighlighted(at: characterRange, highlighted: false)
        return true
    }
}
