//
//  SearchResultTabViewModel.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/10/25.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchResultTabViewModel: BaseViewModel {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let searchButtonTap: ControlEvent<Void>
        let searchText: ControlProperty<String?>
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        
        
        input.searchButtonTap
            .withLatestFrom(input.searchText)
            .bind(with: self) { owner, value in
                guard let text = value?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
                guard !text.isEmpty else { return }
                SearchState.shared.searchText.accept(text)
            }
            .disposed(by: disposeBag)

        return Output()
    }
}
