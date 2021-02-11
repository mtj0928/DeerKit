//
//  UserDefaults+propertyWrapper.swift
//  DeerKit
//
//  Created by 松本淳之介 on 2020/10/10.
//

import Foundation

/// UserDefaultsCompatible is a protocol which can be stored
public protocol UserDefaultsCompatible {

    /// Stores the object with the given key in give UserDefaults
    /// - Parameters:
    ///   - key: key for UserDefaults
    ///   - userDefaults: UserDefaults where the object is stored
    func store(key: String, userDefaults: UserDefaults)

    /// fetch an object with the given key from the given UserDefaults
    /// - Parameters:
    ///   - key: key for UserDefaults
    ///   - userDefaults: UserDefaults which an object is fetched from
    static func fetch(key: String, userDefaults: UserDefaults) -> Self?
}

/// Storage is a propertyWrapper that you can store object to UserDafaults and you can fetch an object from UserDefaults.
@propertyWrapper
public struct Storage<ValueType: UserDefaultsCompatible> {
    public var wrappedValue: ValueType {
        get {
            ValueType.fetch(key: key, userDefaults: userDefaults) ?? defaultValue
        }
        set {
            newValue.store(key: key, userDefaults: userDefaults)
        }
    }

    private let defaultValue: ValueType

    let userDefaults: UserDefaults
    let key: String

    /// Constructor
    /// - Parameters:
    ///   - key: key for UserDefaults
    ///   - defaultValue: the value is returned when UserDefaults has no object for the given key
    ///   - userDefaults: UserDefaults which Storage operates
    public init(key: String, defaultValue: ValueType, userDefaults: UserDefaults = UserDefaults.standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }
}

extension Storage {

    public init<Type>(key: String, userDefaults: UserDefaults = UserDefaults.standard) where ValueType == Optional<Type> {
        self.init(key: key, defaultValue: nil, userDefaults: userDefaults)
    }
}

// MARK: - Int

extension Int: UserDefaultsCompatible {

    public func store(key: String, userDefaults: UserDefaults) {
        userDefaults.set(self, forKey: key)
    }

    public static func fetch(key: String, userDefaults: UserDefaults) -> Int? {
        userDefaults.integer(forKey: key)
    }
}

// MARK: - Double

extension Double: UserDefaultsCompatible {

    public func store(key: String, userDefaults: UserDefaults) {
        userDefaults.setValue(self, forKey: key)
    }

    public static func fetch(key: String, userDefaults: UserDefaults) -> Double? {
        userDefaults.double(forKey: key)
    }
}


// MARK: - Float

extension Float: UserDefaultsCompatible {

    public func store(key: String, userDefaults: UserDefaults) {
        userDefaults.setValue(self, forKey: key)
    }

    public static func fetch(key: String, userDefaults: UserDefaults) -> Float? {
        userDefaults.float(forKey: key)
    }
}

// MARK: - Bool

extension Bool: UserDefaultsCompatible {

    public func store(key: String, userDefaults: UserDefaults) {
        userDefaults.setValue(self, forKey: key)
    }

    public static func fetch(key: String, userDefaults: UserDefaults) -> Bool? {
        userDefaults.bool(forKey: key)
    }
}

// MARK: - String

extension String: UserDefaultsCompatible {

    public func store(key: String, userDefaults: UserDefaults) {
        userDefaults.set(self, forKey: key)
    }

    public static func fetch(key: String, userDefaults: UserDefaults) -> String? {
        userDefaults.string(forKey: key)
    }
}

// MARK: - URL

extension URL: UserDefaultsCompatible {

    public func store(key: String, userDefaults: UserDefaults) {
        userDefaults.setValue(self, forKey: key)
    }

    public static func fetch(key: String, userDefaults: UserDefaults) -> URL? {
        userDefaults.url(forKey: key)
    }
}

// MARK: - Optional

extension Optional: UserDefaultsCompatible where Wrapped: UserDefaultsCompatible {

    public func store(key: String, userDefaults: UserDefaults) {
        if let value = self {
            value.store(key: key, userDefaults: userDefaults)
        } else {
            userDefaults.setValue(nil, forKey: key)
        }
    }

    public static func fetch(key: String, userDefaults: UserDefaults) -> Optional<Wrapped>? {
        Wrapped.fetch(key: key, userDefaults: userDefaults)
    }
}

// MARK: - Codable

private struct CodableWrapper<T: UserDefaultsCompatible & Codable>: Codable {
    let value: T
}

extension UserDefaultsCompatible where Self: Codable {

    public func store(key: String, userDefaults: UserDefaults) {
        let wrapper = CodableWrapper(value: self)
        guard let data = try? JSONEncoder().encode(wrapper) else {
            fatalError("Failed to encode to JSON.")
        }
        userDefaults.setValue(data, forKey: key)
    }

    public static func fetch(key: String, userDefaults: UserDefaults) -> Self? {
        guard let data = userDefaults.data(forKey: key) else {
            return nil
        }
        if let wrapper = try? JSONDecoder().decode(CodableWrapper<Self>.self, from: data) {
            return wrapper.value
        }
        let object = try? JSONDecoder().decode(Self.self, from: data)
        return object
    }
}

// MARK: - Array

extension Array: UserDefaultsCompatible where Element: UserDefaultsCompatible & Codable {}
