//
//  Result.swift
//  Result
//
//  Created by John Gallagher on 9/12/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

import Foundation

public enum Result<T> {
    case Failure(ErrorType)

    // TODO: Get rid of @autoclosure hack at some point after 6.1b1
    case Success(@autoclosure () -> T)

    public var successValue: T? {
        switch self {
        case let .Success(success): return success()
        case .Failure: return nil
        }
    }

    public var failureValue: ErrorType? {
        switch self {
        case .Success: return nil
        case let .Failure(error): return error
        }
    }

    public var isSuccess: Bool {
        switch self {
        case .Success: return true
        case .Failure: return false
        }
    }

    public var isFailure: Bool {
        switch self {
        case .Success: return false
        case .Failure: return true
        }
    }

    public func map<U>(f: T -> U) -> Result<U> {
        switch self {
        case let .Failure(error): return .Failure(error)
        case let .Success(value): return .Success(f(value()))
        }
    }

    public func bind<U>(f: T -> Result<U>) -> Result<U> {
        switch self {
        case let .Failure(error): return .Failure(error)
        case let .Success(value): return f(value())
        }
    }
}

extension Result: Printable {
    public var description: String {
        switch self {
        case let .Failure(error): return "Result.Failure(\(error))"
        case let .Success(value): return "Result.Success(\(value()))"
        }
    }
}