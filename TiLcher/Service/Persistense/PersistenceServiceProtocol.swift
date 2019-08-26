import Foundation

protocol PersistenceServiceProtocol {
    func write<T: RealmObjectConvertable>(objects: [T])
    func read<T: RealmObjectConvertable>(type: T.Type, predicate: NSPredicate) -> [T]
    func write<T: RealmObjectConvertable>(object: T)
}
