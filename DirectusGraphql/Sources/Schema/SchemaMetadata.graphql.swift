// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public typealias ID = String

public protocol SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == DirectusGraphql.SchemaMetadata {}

public protocol InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == DirectusGraphql.SchemaMetadata {}

public protocol MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == DirectusGraphql.SchemaMetadata {}

public protocol MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == DirectusGraphql.SchemaMetadata {}

public enum SchemaMetadata: ApolloAPI.SchemaMetadata {
  public static let configuration: ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

  public static func objectType(forTypename typename: String) -> Object? {
    switch typename {
    case "Mutation": return DirectusGraphql.Objects.Mutation
    case "Start": return DirectusGraphql.Objects.Start
    case "Update": return DirectusGraphql.Objects.Update
    case "Query": return DirectusGraphql.Objects.Query
    case "Projects": return DirectusGraphql.Objects.Projects
    case "Remove": return DirectusGraphql.Objects.Remove
    case "Stop": return DirectusGraphql.Objects.Stop
    case "Log": return DirectusGraphql.Objects.Log
    case "Tasks": return DirectusGraphql.Objects.Tasks
    case "Timers": return DirectusGraphql.Objects.Timers
    case "Task": return DirectusGraphql.Objects.Task
    case "Project": return DirectusGraphql.Objects.Project
    default: return nil
    }
  }
}

public enum Objects {}
public enum Interfaces {}
public enum Unions {}
