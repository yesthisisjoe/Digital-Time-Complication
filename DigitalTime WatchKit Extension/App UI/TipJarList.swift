//
//  TipJarList.swift
//  DigitalTime WatchKit Extension
//
//  Created by Joe Peplowski on 2021-03-21.
//

import SwiftUI
import StoreKit

struct TipJarList: View {
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
      List(products, id: \.productIdentifier) { product in
        Text(product.localizedTitle)
      }
    }
  }
}

struct TipJarList_Previews: PreviewProvider {
  static var previews: some View {
    TipJarList()
  }
}
