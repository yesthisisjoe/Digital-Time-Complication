//
//  DigitalTimeProducts.swift
//  DigitalTime WatchKit Extension
//
//  Created by Joe Peplowski on 2021-03-21.
//

import Foundation

public struct DigitalTimeProducts {
  public static let TipJar1 = "com.yesthisisjoe.DigitalTime.tipJar1"
  private static let productIdentifiers: Set<ProductIdentifier> = [DigitalTimeProducts.TipJar1]
  public static let store = IAPHelper(productIds: DigitalTimeProducts.productIdentifiers)
}
