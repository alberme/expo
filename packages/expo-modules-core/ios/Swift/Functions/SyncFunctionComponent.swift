// Copyright 2022-present 650 Industries. All rights reserved.

/**
 Type-erased protocol for synchronous functions.
 */
internal protocol AnySyncFunctionComponent: AnyFunction {
  /**
   Calls the function synchronously with given arguments.
   - Parameters:
     - args: An array of arguments to pass to the function. The arguments must be of the same type as in the underlying closure.
   - Returns: A value returned by the called function when succeeded or an error when it failed.
   */
  func call(args: [Any]) throws -> Any

  func callWithThis(_ this: Any, args: [Any]) throws -> Any
}

/**
 Represents a function that can only be called synchronously.
 */
public final class SyncFunctionComponent<Args, FirstArgType, ReturnType>: AnySyncFunctionComponent {
  typealias ClosureType = (Args) throws -> ReturnType

  /**
   The underlying closure to run when the function is called.
   */
  let body: ClosureType

  init(
    _ name: String,
    firstArgType: FirstArgType.Type,
    argTypes: [AnyArgumentType],
    _ body: @escaping ClosureType
  ) {
    self.name = name
    self.argumentTypes = argTypes
    self.body = body
  }

  // MARK: - AnyFunction

  let name: String

  let argumentTypes: [AnyArgumentType]

  var argumentsCount: Int {
    return argumentTypes.count
  }

  func call(args: [Any], callback: (FunctionCallResult) -> ()) {
    do {
      let result = try call(args: args)
      callback(.success(result))
    } catch let error as Exception {
      callback(.failure(error))
    } catch {
      callback(.failure(UnexpectedException(error)))
    }
  }

  func callWithThis(_ this: Any, args: [Any], callback: @escaping (FunctionCallResult) -> ()) {
    return call(
      args: concatArguments(args, withThis: this, asType: FirstArgType.self),
      callback: callback
    )
  }

  // MARK: - AnySyncFunctionComponent

  func call(args: [Any]) throws -> Any {
    do {
      let arguments = try castArguments(args, toTypes: argumentTypes)
      let argumentsTuple = try Conversions.toTuple(arguments) as! Args
      return try body(argumentsTuple)
    } catch let error as Exception {
      throw FunctionCallException(name).causedBy(error)
    } catch {
      throw UnexpectedException(error)
    }
  }

  func callWithThis(_ this: Any, args: [Any]) throws -> Any {
    return try call(
      args: concatArguments(args, withThis: this, asType: FirstArgType.self)
    )
  }

  // MARK: - JavaScriptObjectBuilder

  func build(inRuntime runtime: JavaScriptRuntime) -> JavaScriptObject {
    return runtime.createSyncFunction(name, argsCount: argumentsCount) { [weak self, name] this, args in
      guard let self = self else {
        return NativeFunctionUnavailableException(name)
      }
      do {
        return try self.callWithThis(this, args: args)
      } catch {
        return error
      }
    }
  }
}

/**
 Synchronous function without arguments.
 */
public func Function<R>(
  _ name: String,
  _ closure: @escaping () throws -> R
) -> SyncFunctionComponent<(), Void, R> {
  return SyncFunctionComponent(
    name,
    firstArgType: Void.self,
    argTypes: [],
    closure
  )
}

/**
 Synchronous function with one argument.
 */
public func Function<R, A0: AnyArgument>(
  _ name: String,
  _ closure: @escaping (A0) throws -> R
) -> SyncFunctionComponent<(A0), A0, R> {
  return SyncFunctionComponent(
    name,
    firstArgType: A0.self,
    argTypes: [ArgumentType(A0.self)],
    closure
  )
}

/**
 Synchronous function with two arguments.
 */
public func Function<R, A0: AnyArgument, A1: AnyArgument>(
  _ name: String,
  _ closure: @escaping (A0, A1) throws -> R
) -> SyncFunctionComponent<(A0, A1), A0, R> {
  return SyncFunctionComponent(
    name,
    firstArgType: A0.self,
    argTypes: [ArgumentType(A0.self), ArgumentType(A1.self)],
    closure
  )
}

/**
 Synchronous function with three arguments.
 */
public func Function<R, A0: AnyArgument, A1: AnyArgument, A2: AnyArgument>(
  _ name: String,
  _ closure: @escaping (A0, A1, A2) throws -> R
) -> SyncFunctionComponent<(A0, A1, A2), A0, R> {
  return SyncFunctionComponent(
    name,
    firstArgType: A0.self,
    argTypes: [
      ArgumentType(A0.self),
      ArgumentType(A1.self),
      ArgumentType(A2.self)
    ],
    closure
  )
}

/**
 Synchronous function with four arguments.
 */
public func Function<R, A0: AnyArgument, A1: AnyArgument, A2: AnyArgument, A3: AnyArgument>(
  _ name: String,
  _ closure: @escaping (A0, A1, A2, A3) throws -> R
) -> SyncFunctionComponent<(A0, A1, A2, A3), A0, R> {
  return SyncFunctionComponent(
    name,
    firstArgType: A0.self,
    argTypes: [
      ArgumentType(A0.self),
      ArgumentType(A1.self),
      ArgumentType(A2.self),
      ArgumentType(A3.self)
    ],
    closure
  )
}

/**
 Synchronous function with five arguments.
 */
public func Function<R, A0: AnyArgument, A1: AnyArgument, A2: AnyArgument, A3: AnyArgument, A4: AnyArgument>(
  _ name: String,
  _ closure: @escaping (A0, A1, A2, A3, A4) throws -> R
) -> SyncFunctionComponent<(A0, A1, A2, A3, A4), A0, R> {
  return SyncFunctionComponent(
    name,
    firstArgType: A0.self,
    argTypes: [
      ArgumentType(A0.self),
      ArgumentType(A1.self),
      ArgumentType(A2.self),
      ArgumentType(A3.self),
      ArgumentType(A4.self)
    ],
    closure
  )
}

/**
 Synchronous function with six arguments.
 */
public func Function<R, A0: AnyArgument, A1: AnyArgument, A2: AnyArgument, A3: AnyArgument, A4: AnyArgument, A5: AnyArgument>(
  _ name: String,
  _ closure: @escaping (A0, A1, A2, A3, A4, A5) throws -> R
) -> SyncFunctionComponent<(A0, A1, A2, A3, A4, A5), A0, R> {
  return SyncFunctionComponent(
    name,
    firstArgType: A0.self,
    argTypes: [
      ArgumentType(A0.self),
      ArgumentType(A1.self),
      ArgumentType(A2.self),
      ArgumentType(A3.self),
      ArgumentType(A4.self),
      ArgumentType(A5.self)
    ],
    closure
  )
}

/**
 Synchronous function with seven arguments.
 */
public func Function<R, A0: AnyArgument, A1: AnyArgument, A2: AnyArgument, A3: AnyArgument, A4: AnyArgument, A5: AnyArgument, A6: AnyArgument>(
  _ name: String,
  _ closure: @escaping (A0, A1, A2, A3, A4, A5, A6) throws -> R
) -> SyncFunctionComponent<(A0, A1, A2, A3, A4, A5, A6), A0, R> {
  return SyncFunctionComponent(
    name,
    firstArgType: A0.self,
    argTypes: [
      ArgumentType(A0.self),
      ArgumentType(A1.self),
      ArgumentType(A2.self),
      ArgumentType(A3.self),
      ArgumentType(A4.self),
      ArgumentType(A5.self),
      ArgumentType(A6.self)
    ],
    closure
  )
}

/**
 Synchronous function with eight arguments.
 */
public func Function<R, A0: AnyArgument, A1: AnyArgument, A2: AnyArgument, A3: AnyArgument, A4: AnyArgument, A5: AnyArgument, A6: AnyArgument, A7: AnyArgument>(
  _ name: String,
  _ closure: @escaping (A0, A1, A2, A3, A4, A5, A6, A7) throws -> R
) -> SyncFunctionComponent<(A0, A1, A2, A3, A4, A5, A6, A7), A0, R> {
  return SyncFunctionComponent(
    name,
    firstArgType: A0.self,
    argTypes: [
      ArgumentType(A0.self),
      ArgumentType(A1.self),
      ArgumentType(A2.self),
      ArgumentType(A3.self),
      ArgumentType(A4.self),
      ArgumentType(A5.self),
      ArgumentType(A6.self),
      ArgumentType(A7.self)
    ],
    closure
  )
}
