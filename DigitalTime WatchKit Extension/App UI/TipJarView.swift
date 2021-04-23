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
  @State private var showingSuccessAlert = false
  @State private var showingFailureAlert = false
  let publisher = NotificationCenter.default.publisher(for: .IAPHelperPurchaseNotification)

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
            Text("Enjoying the app? Select an amount below to send a tip to the developer!")
            .textCase(.none)
        ) {
          ForEach(products, id: \.productIdentifier) { product in
            Button(DigitalTimeProducts.store.formattedPriceForProduct(product)) {
              DigitalTimeProducts.store.buyProduct(product)
            }
          }
        }
      }
      .onReceive(publisher) { output in
        if let success = output.object as? Bool {
          if success {
            showingSuccessAlert = true
          } else {
            showingFailureAlert = true
          }
        }
      }
      .alert(isPresented: $showingSuccessAlert) {
        Alert(
          title: Text("Tip Received"),
          message: Text("Thank you for your support!"),
          dismissButton: .default(Text("OK")))
      }
      .alert(isPresented: $showingFailureAlert) {
        Alert(
          title: Text("Purchase Failed"),
          message: Text("Please try tipping again."),
          dismissButton: .default(Text("OK")))
      }
    }
  }
}

struct TipJarList_Previews: PreviewProvider {
  static var previews: some View {
    TipJarView(products: [SKProduct()])
  }
}
