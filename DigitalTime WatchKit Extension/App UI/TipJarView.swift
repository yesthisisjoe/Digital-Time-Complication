//
//  TipJarView.swift
//  DigitalTime WatchKit Extension
//
//  Created by Joe Peplowski on 2021-03-21.
//

import SwiftUI
import StoreKit

struct TipJarView: View {

  struct AlertItem: Identifiable {
    var id = UUID()
    var title: Text
    var message: Text?
    var dismissButton: Alert.Button?
  }

  @State var products: [SKProduct] = []
  @State private var alertItem: AlertItem?
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
            alertItem = AlertItem(
              title: Text("Tip Received"),
              message: Text("Thank you for your support!"),
              dismissButton: .default(Text("OK")))
          } else {
            alertItem = AlertItem(
              title: Text("Purchase Failed"),
              message: Text("Please try tipping again."),
              dismissButton: .default(Text("OK")))
          }
        }
      }
      .alert(item: $alertItem) { alertItem in
        Alert(
          title: alertItem.title,
          message: alertItem.message,
          dismissButton: alertItem.dismissButton)
      }
    }
  }
}

struct TipJarList_Previews: PreviewProvider {
  static var previews: some View {
    TipJarView(products: [SKProduct()])
  }
}
