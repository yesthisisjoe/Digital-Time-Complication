//
//  TipJarView.swift
//  DigitalTime WatchKit Extension
//
//  Created by Joe Peplowski on 2021-03-21.
//

import SwiftUI
import StoreKit

struct TipJarView: View {
  @State var products: [SKProduct] = []

  var body: some View {
    if products.isEmpty {
      Text("Loading Tip Jar")
        .onAppear {
          DigitalTimeProducts.store.requestProducts { success, products in
            if success {
              self.products = products!
            }
          }
        }
    } else {
      VStack {
        List {
          Section(
            header:
              Text("Select a tip amount to show your appreciation for Digital Time")
              .textCase(.none)
          ) {
            ForEach(products, id: \.productIdentifier) { product in
              Text(DigitalTimeProducts.store.formattedPriceForProduct(product))
            }
          }
        }
      }
    }
  }
}

struct TipJarList_Previews: PreviewProvider {
  static var previews: some View {
    TipJarView(products: [SKProduct()])
  }
}
