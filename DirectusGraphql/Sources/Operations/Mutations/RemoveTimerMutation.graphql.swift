// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class RemoveTimerMutation: GraphQLMutation {
  public static let operationName: String = "RemoveTimer"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation RemoveTimer($removeId: Int!) { remove(timerId: $removeId) { __typename id } }"#
    ))

  public var removeId: Int

  public init(removeId: Int) {
    self.removeId = removeId
  }

  public var __variables: Variables? { ["removeId": removeId] }

  public struct Data: DirectusGraphql.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { DirectusGraphql.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("remove", Remove?.self, arguments: ["timerId": .variable("removeId")]),
    ] }

    public var remove: Remove? { __data["remove"] }

    /// Remove
    ///
    /// Parent Type: `Remove`
    public struct Remove: DirectusGraphql.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { DirectusGraphql.Objects.Remove }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", Int?.self),
      ] }

      public var id: Int? { __data["id"] }
    }
  }
}
