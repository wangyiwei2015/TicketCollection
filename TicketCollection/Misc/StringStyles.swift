//
//  StringStyles.swift
//  TicketCollection
//
//  Created by leo on 2025.08.18.
//

import SwiftUI

extension String {
    // AttributedString
    
    @inlinable func stroke(
        _ color: Color = .primary, width: CGFloat
    ) -> AttributedString {
        var attributedString = AttributedString(self)
        //let container = AttributeContainer()
            //.foregroundColor(color)
            //.strokeWidth(width)
            //.strokeColor(.primary)
        attributedString.strokeColor = UIColor.black
        attributedString.strokeWidth = width
        //attributedString.mergeAttributes(container)
        return attributedString
    }
    
    @inlinable func kern(
        _ color: Color = .primary, spacing: CGFloat
    ) -> AttributedString {
        var attributedString = AttributedString(self)
        let container = AttributeContainer()
            .foregroundColor(color)
            .kern(spacing)
        attributedString.mergeAttributes(container)
        return attributedString
    }
}
