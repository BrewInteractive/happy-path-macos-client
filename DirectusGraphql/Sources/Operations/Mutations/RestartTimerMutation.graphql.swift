// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class RestartTimerMutation: GraphQLMutation {
  public static let operationName: String = "RestartTimer"
  public static let document: ApolloAPI.DocumentType = .notPersisted(
    definition: .init(
      #"""
      mutation RestartTimer($timerId: Int!) {
        restart(timerId: $timerId) {
          __typename
          id
        }
      }
      """#
    ))

  public var timerId: Int

  public init(timerId: Int) {
    self.timerId = timerId
  }

  public var __variables: Variables? { ["timerId": timerId] }

  public struct Data: DirectusGraphql.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { DirectusGraphql.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("restart", Restart?.self, arguments: ["timerId": .variable("timerId")]),
    ] }

    public var restart: Restart? { __data["restart"] }

    /// Restart
    ///
    /// Parent Type: `Restart`
    public struct Restart: DirectusGraphql.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { DirectusGraphql.Objects.Restart }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", Int?.self),
      ] }

      public var id: Int? { __data["id"] }
    }
  }
}
