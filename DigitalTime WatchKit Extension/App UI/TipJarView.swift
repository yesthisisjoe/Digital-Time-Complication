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
      List {
        Section(
          header:
            Text("Select a tip amount to show your appreciation for Digital Time")
            .textCase(.none)
        ) {
          ForEach(products, id: \.productIdentifier) { product in
            Button(DigitalTimeProducts.store.formattedPriceForProduct(product)) {
              DigitalTimeProducts.store.buyProduct(product)
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
