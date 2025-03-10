//
//  SearchState.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/10/25.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchState {
    static let shared = SearchState()
    private init() {}
    var searchText = BehaviorRelay(value: "")
}
