
#if swift(>=5.4)
/**
 A function builder that provides DSL-like syntax. Thanks to this, the function doesn't need to explicitly return an array,
 but can just return multiple methods one after another. This works similarly to SwiftUI's `body` block.
 */
@resultBuilder
public struct ModuleDefinitionBuilder {
  public static func buildBlock(_ components: AnyDefinition...) -> ModuleDefinition {
    return ModuleDefinition(components: components)
  }
}
#endif
