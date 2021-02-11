import XCTest
@testable import DeerKit

private let userDefaults = UserDefaults(suiteName: "DeerKit.UserDefaultsTest")!

struct CodableObject: UserDefaultsCompatible, Codable, Equatable {
    static let defaultValue = CodableObject(string: "default", int: 0)

    let string: String
    let int: Int
}

private final class TestObject {

    enum Key: String, CaseIterable {
        case string, int, double, float, bool, codable, optional, optionalDate, array
    }

    @Storage(key: Key.string.rawValue, defaultValue: "default", userDefaults: userDefaults) var string: String
    @Storage(key: Key.int.rawValue, defaultValue: 0, userDefaults: userDefaults) var int: Int
    @Storage(key: Key.double.rawValue, defaultValue: 0.0, userDefaults: userDefaults) var double: Double
    @Storage(key: Key.float.rawValue, defaultValue: 0.0, userDefaults: userDefaults) var float: Float
    @Storage(key: Key.bool.rawValue, defaultValue: false, userDefaults: userDefaults) var bool: Bool
    @Storage(key: Key.codable.rawValue, defaultValue: CodableObject.defaultValue, userDefaults: userDefaults) var codable: CodableObject
    @Storage(key: Key.optional.rawValue, userDefaults: userDefaults) var optional: String?
    @Storage(key: Key.optionalDate.rawValue, userDefaults: userDefaults) var optionalDate: Date?
    @Storage(key: Key.array.rawValue, defaultValue: [], userDefaults: userDefaults) var array: [CodableObject]
}

final class UserDefaultsTest: XCTestCase {

    static var allTests = [
        ("testDefaultValueAndWrite", testDefaultValueAndWrite),
    ]

    override func setUpWithError() throws {
        TestObject.Key.allCases.forEach { key in
            userDefaults.removeObject(forKey: key.rawValue)
        }
    }

    func testDefaultValueAndWrite() throws {
        changeTest(\TestObject.string, defaultValue: "default", changeValue: "change")
        changeTest(\TestObject.int, defaultValue: 0, changeValue: 100)
        changeTest(\TestObject.double, defaultValue: 0.0, changeValue: 100.0)
        changeTest(\TestObject.float, defaultValue: 0.0, changeValue: 100.0)
        changeTest(\TestObject.bool, defaultValue: false, changeValue: true)
        changeTest(\TestObject.codable, defaultValue: .defaultValue, changeValue: CodableObject(string: "change", int: 100))
        changeTest(\TestObject.optional, defaultValue: nil, changeValue: "Change")
        changeTest(\TestObject.optionalDate, defaultValue: nil, changeValue: Date())
        changeTest(\TestObject.array, defaultValue: [], changeValue: [
            CodableObject(string: "change", int: 0),
            CodableObject(string: "change", int: 1),
            CodableObject(string: "change", int: 2)
        ])
    }

    private func changeTest<Type: Equatable>(_ keyPath: WritableKeyPath<TestObject, Type>, defaultValue: Type, changeValue: Type) {
        var object = TestObject()
        XCTAssertEqual(object[keyPath: keyPath], defaultValue)

        object[keyPath: keyPath] = changeValue
        XCTAssertEqual(object[keyPath: keyPath], changeValue)
    }
}

extension Date: UserDefaultsCompatible {}
