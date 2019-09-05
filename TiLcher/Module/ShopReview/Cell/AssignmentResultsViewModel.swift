import Foundation

final class AssignmentResultsViewModel {
    private let looksChange: (Int) -> Void
    private let collagesChange: (Int) -> Void
    private let storiesChange: (Int) -> Void
    private let postsChange: (Int) -> Void

    init(
        looksChange: @escaping (Int) -> Void,
        collagesChange: @escaping (Int) -> Void,
        storiesChange: @escaping (Int) -> Void,
        postsChange: @escaping (Int) -> Void
    ) {
        self.looksChange = looksChange
        self.collagesChange = collagesChange
        self.storiesChange = storiesChange
        self.postsChange = postsChange
    }

    lazy var looksChangeString: (String) -> Void = {
        stringToIntWrapper(intClosure: self.looksChange)
    }()

    lazy var collagesChangeString: (String) -> Void = {
        stringToIntWrapper(intClosure: self.collagesChange)
    }()

    lazy var storiesChangeString: (String) -> Void = {
        stringToIntWrapper(intClosure: self.storiesChange)
    }()

    lazy var postsChangeString: (String) -> Void = {
        stringToIntWrapper(intClosure: self.postsChange)
    }()

    private func stringToIntWrapper(intClosure: @escaping (Int) -> Void) -> (String) -> Void {
        return { stringValue in
            guard let value = Int(stringValue) else {
                return
            }
            intClosure(value)
        }
    }
}
