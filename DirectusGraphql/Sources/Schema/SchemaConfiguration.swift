// @generated
// This file was automatically generated and can be edited to
// provide custom configuration for a generated GraphQL schema.
//
// Any changes to this file will not be overwritten by future
// code generation execution.

import ApolloAPI

public enum SchemaConfiguration: ApolloAPI.SchemaConfiguration {
  public static func cacheKeyInfo(for type: Object, object: ObjectData) -> CacheKeyInfo? {
    // Implement this function to configure cache key resolution for your schema types.
      switch type {
      case Objects.Timers:
          return nil
      default:
          guard let id = object["id"] as? String else {
              return nil
          }
          
          return CacheKeyInfo(id: id)
      }
  }
}
