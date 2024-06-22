// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class LogTimerMutation: GraphQLMutation {
  public static let operationName: String = "LogTimer"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation LogTimer($projectTaskId: Int!, $duration: Int!, $notes: String!, $startsAt: String!, $endsAt: String!, $relations: [String]) { log( projectTaskId: $projectTaskId duration: $duration notes: $notes startsAt: $startsAt endsAt: $endsAt relations: $relations ) { __typename id startsAt endsAt duration } }"#
    ))

  public var projectTaskId: Int
  public var duration: Int
  public var notes: String
  public var startsAt: String
  public var endsAt: String
  public var relations: GraphQLNullable<[String?]>

  public init(
    projectTaskId: Int,
    duration: Int,
    notes: String,
    startsAt: String,
    endsAt: String,
    relations: GraphQLNullable<[String?]>
  ) {
    self.projectTaskId = projectTaskId
    self.duration = duration
    self.notes = notes
    self.startsAt = startsAt
    self.endsAt = endsAt
    self.relations = relations
  }

  public var __variables: Variables? { [
    "projectTaskId": projectTaskId,
    "duration": duration,
    "notes": notes,
    "startsAt": startsAt,
    "endsAt": endsAt,
    "relations": relations
  ] }

  public struct Data: DirectusGraphql.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { DirectusGraphql.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("log", Log?.self, arguments: [
        "projectTaskId": .variable("projectTaskId"),
        "duration": .variable("duration"),
        "notes": .variable("notes"),
        "startsAt": .variable("startsAt"),
        "endsAt": .variable("endsAt"),
        "relations": .variable("relations")
      ]),
    ] }

    public var log: Log? { __data["log"] }

    /// Log
    ///
    /// Parent Type: `Log`
    public struct Log: DirectusGraphql.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { DirectusGraphql.Objects.Log }
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
