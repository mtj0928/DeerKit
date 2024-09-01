import XCTest
import Combine

extension XCTestCase {

    struct CompetionResult {
        let expectation: XCTestExpectation
        let cancellable: AnyCancellable
    }

    func expectValues<T: Publisher>(
        of publisher: T,
        equals expects: [T.Output]
    ) -> CompetionResult where T.Output: Equatable {
        let expectation = expectation(description: "Correct values of " + String(describing: publisher))
        var expects = expects
        let cancellable = publisher.sink(
            receiveCompletion: { _ in },
            receiveValue: { value in
                XCTAssertFalse(expects.isEmpty)
                XCTAssertEqual(value, expects.first)

                if !expects.isEmpty  {
                    expects.removeFirst()
                }

                if expects.isEmpty {
                    expectation.fulfill()
                }
            }
        )
        return .init(expectation: expectation, cancellable: cancellable)
    }
}
