// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class GetProjectsQuery: GraphQLQuery {
  public static let operationName: String = "getProjects"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query getProjects { projects { __typename id projectName } }"#
    ))

  public init() {}

  public struct Data: DirectusGraphql.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { DirectusGraphql.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("projects", [Project?]?.self),
    ] }

    public var projects: [Project?]? { __data["projects"] }

    /// Project
    ///
    /// Parent Type: `Projects`
    public struct Project: DirectusGraphql.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { DirectusGraphql.Objects.Projects }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", String?.self),
        .field("projectName", String?.self),
      ] }

      public var id: String? { __data["id"] }
      public var projectName: String? { __data["projectName"] }
    }
  }
}
