//
//  ServerMessageItemView.swift
//  Maia
//
//  Created by José Ruiz on 10/7/24.
//

import SwiftUI

struct StoreMessageItemView: View {
    let message: Message
    
    var body: some View {
        HStack {
            Spacer()
            Text(message.text)
                .padding(8)
                .background(Color.blue)
                .cornerRadius(12)
                .foregroundColor(.white)
                .font(.body)
                .frame(maxWidth: .infinity * 0.8, alignment: .trailing)
        }
        .padding(.trailing, 12)
    }
}
