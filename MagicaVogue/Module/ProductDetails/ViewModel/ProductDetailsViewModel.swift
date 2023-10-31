//
//  ProductDetailsViewModel.swift
//  MagicaVogue
//
//  Created by Gsm on 29/10/2023.
//

import Foundation
class ProductDetailsViewModel{
    var currentCell = 0
    var customerid = 7471279866172
    var selectedIndexPathForSize: IndexPath?
    var selectedIndexPathForColor: IndexPath?
    
    var timer: Timer?
    
    
    var productSizes: [ProductOption] = []
    var productColors: [ProductOption] = []
    
    var arrOfProductImgs: [String] = []
    var arrOfSize: [String] = []
    var arrOfColor: [String] = []
    
    var myProduct : Products!
    var cart: [Products] = []
    
    
    
    
}

