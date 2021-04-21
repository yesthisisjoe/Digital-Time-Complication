//
//  DigitalTimeProducts.swift
//  DigitalTime WatchKit Extension
//
//  Created by Joe Peplowski on 2021-03-21.
//

import StoreKit

public struct DigitalTimeProducts {
  public static let TipJar1 = "com.yesthisisjoe.DigitalTime.tipJar1"
//  public static let TipJar2 = "com.yesthisisjoe.DigitalTime.tipJar2"
  public static let TipJar3 = "com.yesthisisjoe.DigitalTime.tipJar3"
//  public static let TipJar4 = "com.yesthisisjoe.DigitalTime.tipJar4"
  public static let TipJar5 = "com.yesthisisjoe.DigitalTime.tipJar5"
  private static let productIdentifiers: Set<ProductIdentifier> = [
    DigitalTimeProducts.TipJar1,
//    DigitalTimeProducts.TipJar2,
    DigitalTimeProducts.TipJar3,
//    DigitalTimeProducts.TipJar4,
    DigitalTimeProducts.TipJar5
  ]
  public static let store = IAPHelper(productIds: DigitalTimeProducts.productIdentifiers)
}
