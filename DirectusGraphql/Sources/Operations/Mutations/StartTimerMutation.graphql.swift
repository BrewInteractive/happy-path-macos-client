// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class StartTimerMutation: GraphQLMutation {
  public static let operationName: String = "StartTimer"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation StartTimer($projectTaskId: Int!, $duration: Int, $notes: String, $relations: [String]) { start( projectTaskId: $projectTaskId duration: $duration notes: $notes relations: $relations ) { __typename id startsAt endsAt duration } }"#
    ))

  public var projectTaskId: Int
  public var duration: GraphQLNullable<Int>
  public var notes: GraphQLNullable<String>
  public var relations: GraphQLNullable<[String?]>

  public init(
    projectTaskId: Int,
    duration: GraphQLNullable<Int>,
    notes: GraphQLNullable<String>,
    relations: GraphQLNullable<[String?]>
  ) {
    self.projectTaskId = projectTaskId
    self.duration = duration
    self.notes = notes
    self.relations = relations
  }

  public var __variables: Variables? { [
    "projectTaskId": projectTaskId,
    "duration": duration,
    "notes": notes,
    "relations": relations
  ] }

  public struct Data: DirectusGraphql.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { DirectusGraphql.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("start", Start?.self, arguments: [
        "projectTaskId": .variable("projectTaskId"),
        "duration": .variable("duration"),
        "notes": .variable("notes"),
        "relations": .variable("relations")
      ]),
    ] }

    public var start: Start? { __data["start"] }

    /// Start
    ///
    /// Parent Type: `Start`
    public struct Start: DirectusGraphql.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { DirectusGraphql.Objects.Start }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", String?.self),
        .field("startsAt", String?.self),
        .field("endsAt", String?.self),
        .field("duration", Int?.self),
      ] }

      public var id: String? { __data["id"] }
      public var startsAt: String? { __data["startsAt"] }
      public var endsAt: String? { __data["endsAt"] }
      public var duration: Int? { __data["duration"] }
    }
  }
}
