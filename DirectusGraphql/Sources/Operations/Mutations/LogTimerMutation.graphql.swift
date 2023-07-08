// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class LogTimerMutation: GraphQLMutation {
  public static let operationName: String = "LogTimer"
  public static let document: ApolloAPI.DocumentType = .notPersisted(
    definition: .init(
      #"""
      mutation LogTimer($projectTasktId: Int!, $duration: Int!, $notes: String!, $startsAt: String!, $endsAt: String!) {
        log(
          projectTaskId: $projectTasktId
          duration: $duration
          notes: $notes
          startsAt: $startsAt
          endsAt: $endsAt
        ) {
          __typename
          id
        }
      }
      """#
    ))

  public var projectTasktId: Int
  public var duration: Int
  public var notes: String
  public var startsAt: String
  public var endsAt: String

  public init(
    projectTasktId: Int,
    duration: Int,
    notes: String,
    startsAt: String,
    endsAt: String
  ) {
    self.projectTasktId = projectTasktId
    self.duration = duration
    self.notes = notes
    self.startsAt = startsAt
    self.endsAt = endsAt
  }

  public var __variables: Variables? { [
    "projectTasktId": projectTasktId,
    "duration": duration,
    "notes": notes,
    "startsAt": startsAt,
    "endsAt": endsAt
  ] }

  public struct Data: DirectusGraphql.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { DirectusGraphql.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("log", Log?.self, arguments: [
        "projectTaskId": .variable("projectTasktId"),
        "duration": .variable("duration"),
        "notes": .variable("notes"),
        "startsAt": .variable("startsAt"),
        "endsAt": .variable("endsAt")
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
      ] }

      public var id: String? { __data["id"] }
    }
  }
}
