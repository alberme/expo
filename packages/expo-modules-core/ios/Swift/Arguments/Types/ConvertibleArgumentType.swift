// Copyright 2021-present 650 Industries. All rights reserved.

/**
 An argument type that wraps any type conforming to `ConvertibleArgument` protocol.
 */
internal struct ConvertibleArgumentType: AnyArgumentType {
  let innerType: ConvertibleArgument.Type

  func wraps<InnerType>(_ type: InnerType.Type) -> Bool {
    return innerType == InnerType.self
  }

  func equals(_ type: AnyArgumentType) -> Bool {
    if let convertibleType = type as? Self {
      return convertibleType.innerType == innerType
    }
    return false
  }

  func cast<ArgType>(_ value: ArgType) throws -> Any {
    return try innerType.convert(from: value)
  }

  var description: String {
    String(describing: innerType.self)
  }
}
