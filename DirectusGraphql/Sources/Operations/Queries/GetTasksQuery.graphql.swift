// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class GetTasksQuery: GraphQLQuery {
  public static let operationName: String = "getTasks"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query getTasks($projectId: Int!) { tasks(projectId: $projectId) { __typename id taskName } }"#
    ))

  public var projectId: Int

  public init(projectId: Int) {
    self.projectId = projectId
  }

  public var __variables: Variables? { ["projectId": projectId] }

  public struct Data: DirectusGraphql.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { DirectusGraphql.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("tasks", [Task?]?.self, arguments: ["projectId": .variable("projectId")]),
    ] }

    public var tasks: [Task?]? { __data["tasks"] }

    /// Task
    ///
    /// Parent Type: `Tasks`
    public struct Task: DirectusGraphql.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { DirectusGraphql.Objects.Tasks }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", String?.self),
        .field("taskName", String?.self),
      ] }

      public var id: String? { __data["id"] }
      public var taskName: String? { __data["taskName"] }
    }
  }
}
