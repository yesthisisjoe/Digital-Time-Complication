//
//  IAPHelper.swift
//  DigitalTime WatchKit Extension
//
//  Created by Joe Peplowski on 2021-03-21.
//

import StoreKit

public typealias ProductIdentifier = String
public typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> Void

extension Notification.Name {
  static let IAPHelperPurchaseNotification = Notification.Name("IAPHelperPurchaseNotification")
}

open class IAPHelper: NSObject {
  private let productIdentifiers: Set<ProductIdentifier>

  private var purchasedProductIdentifiers: Set<ProductIdentifier> = []
  private var productsRequest: SKProductsRequest?
  private var productsRequestCompletionHandler: ProductsRequestCompletionHandler?

  public init(productIds: Set<ProductIdentifier>) {
    productIdentifiers = productIds
    super.init()
  }
}

// MARK: - StoreKit API

extension IAPHelper {
  public func requestProducts(_ completionHandler: @escaping ProductsRequestCompletionHandler) {
    productsRequest?.cancel()
    productsRequestCompletionHandler = completionHandler

    productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
    productsRequest!.delegate = self
    productsRequest!.start()
  }

  public func buyProduct(_ product: SKProduct) {
  }

  // Necessary?
  public func isProductPurchased(_ productIdentifier: ProductIdentifier) -> Bool {
    return false
  }

  public class func canMakePayments() -> Bool {
    return true
  }

  // Necessary?
  public func restorePurchases() {
  }
}

// MARK: - SKProductsRequestDelegate

extension IAPHelper: SKProductsRequestDelegate {

  public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
    print("Loaded list of products...")
    let products = response.products
    productsRequestCompletionHandler?(true, products)
    clearRequestAndHandler()

    for product in products {
      print("Found product: \(product.productIdentifier) \(product.localizedTitle) \(product.price.floatValue)")
    }
  }

  public func request(_ request: SKRequest, didFailWithError error: Error) {
    print("Failed to load list of products.")
    print("Error: \(error.localizedDescription)")
    productsRequestCompletionHandler?(false, nil)
    clearRequestAndHandler()
  }

  private func clearRequestAndHandler() {
    productsRequest = nil
    productsRequestCompletionHandler = nil
  }
}
