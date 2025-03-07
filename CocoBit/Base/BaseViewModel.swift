//
//  BaseViewModel.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/7/25.
//

import Foundation
import RxSwift

protocol BaseViewModel {
    associatedtype Input
    associatedtype Output
    var disposeBag: DisposeBag { get set }
    
    func transform(input: Input) -> Output
}
