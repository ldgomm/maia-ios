//
//  ConversationItemView.swift
//  Maia
//
//  Created by José Ruiz on 10/7/24.
//

import SwiftUI

struct ConversationItemView: View {
    let message: Message
    var sentOrDeliveredCount: Int

    var body: some View {
        HStack {
            Image(systemName: "person.circle")
                .resizable()
                .frame(width: 30, height: 30)
                .clipShape(Circle())
                .padding(.horizontal, 12)

            VStack(alignment: .leading) {
                Text(message.clientId.firstSixChars().lowercased())
                    .font(.headline)
                Text(message.text)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                    .padding(.top, 2)
            }
            Spacer()
            VStack {
                // Date text
                Text(message.date.formatShortDate)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.trailing, 10)

                // Message count badge
                if sentOrDeliveredCount > 0 {
                    ZStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 20, height: 20) // Adjust size as needed
                        Text("\(sentOrDeliveredCount)")
                            .font(.footnote)
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
}
