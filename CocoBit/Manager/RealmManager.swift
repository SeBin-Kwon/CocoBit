//
//  RealmManager.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/11/25.
//

import Foundation
import RxSwift
import RealmSwift

enum RealmManager {

    private static var realm: Realm {
        try! Realm()
    }
    
    @CocobitDataBase(type: FavoriteTable.self) static var favoriteTable
    
    @propertyWrapper private class CocobitDataBase<T: Object> {
        let type: T.Type
        let value: BehaviorSubject<[T]>
        let disposeBag = DisposeBag()
        
        init(type: T.Type) {
            self.type = type
            self.value = BehaviorSubject(value: Array(RealmManager.read(T.self)))
            
            RealmManager.observe(type)
                .bind(with: self) { owner, value in
                    owner.value.onNext(value)
                }
                .disposed(by: disposeBag)
        }
        
        var wrappedValue: Results<T> {
            get { RealmManager.read(type) }
        }

        var projectedValue: BehaviorSubject<[T]> {
            return value
        }
        
        func updateValue(_ value: [T]) {
            self.value.onNext(value)
        }
    }
    
    static func getFileURL() {
        print(realm.configuration.fileURL)
    }
    
    static func findData<T: Object>(_ itemType: T.Type, key: String) -> T? {
        return realm.object(ofType: itemType, forPrimaryKey: key)
    }
    
    static func observe<T: Object>(_ type: T.Type) -> Observable<[T]> {
        let results = RealmManager.realm.objects(type)
            
            return Observable.create { observer in
                let token = results.observe { changes in
                    switch changes {
                    case .initial(let items):
                        observer.onNext(Array(items))
                    case .update(let items, _, _, _):
                        observer.onNext(Array(items))
                    case .error(let error):
                        observer.onError(error)
                    }
                }
                
                return Disposables.create {
                    token.invalidate()
                }
            }
        }
    
    static func read<T: Object>(_ itemType: T.Type) -> Results<T> {
        return realm.objects(itemType)
    }
    
    static func add<T: Object>(_ item: T) {
        do {
            try realm.write {
                realm.add(item, update: .modified)
                print("렘 저장 완료")
            }
        } catch let error {
            print("렘에서 저장이 실패한 경우", error)
        }
    }
    
    static func delete<T: Object>(_ item: T) {
        do {
            try realm.write {
                realm.delete(item)
                print("렘 삭제 완료")
            }
        } catch let error {
            print("렘 데이터 삭제 실패", error)
        }
    }

}

