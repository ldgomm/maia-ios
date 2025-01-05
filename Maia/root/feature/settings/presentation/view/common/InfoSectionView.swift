//
//  InfoSectionView.swift
//  Maia
//
//  Created by José Ruiz on 29/7/24.
//

import SwiftUI

struct InfoSectionView<Content: View>: View {
    var title: String
    var content: String?
    var icon: String?
    var iconColor: Color?
    @ViewBuilder var customContent: Content
    
    init(title: String, content: String? = nil, icon: String? = nil, iconColor: Color? = nil, @ViewBuilder customContent: () -> Content = { EmptyView() }) {
        self.title = title
        self.content = content
        self.icon = icon
        self.iconColor = iconColor
        self.customContent = customContent()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            HStack {
                if let icon = icon, let iconColor = iconColor {
                    Image(systemName: icon)
                        .foregroundColor(iconColor)
                }
                if let content = content {
                    Text(content)
                } else {
                    customContent
                }
            }
            .padding(.bottom, 10)
        }
    }
}

