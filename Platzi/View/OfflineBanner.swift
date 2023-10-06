//
//  OfflineBanner.swift
//  Platzi
//
//  Created by Melissa Zellhuber on 05/10/23.
//

import SwiftUI

struct OfflineBanner: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.red)
                .frame(height: 50)
            Text("Offline Mode")
                .foregroundColor(.white)
                .padding()
        }
    }
}

#Preview {
    OfflineBanner()
}
