// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class GetTimersQuery: GraphQLQuery {
  public static let operationName: String = "getTimers"
  public static let document: ApolloAPI.DocumentType = .notPersisted(
    definition: .init(
      #"""
      query getTimers($startsAt: String!, $endsAt: String!) {
        timers(startsAt: $startsAt, endsAt: $endsAt) {
          __typename
          id
          endsAt
          startsAt
          duration
          totalDuration
          task {
            __typename
            id
            name
          }
          project {
            __typename
            id
            name
          }
          notes
        }
      }
      """#
    ))

  public var startsAt: String
  public var endsAt: String

  public init(
    startsAt: String,
    endsAt: String
  ) {
    self.startsAt = startsAt
    self.endsAt = endsAt
  }

  public var __variables: Variables? { [
    "startsAt": startsAt,
    "endsAt": endsAt
  ] }

  public struct Data: DirectusGraphql.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { DirectusGraphql.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("timers", [Timer?]?.self, arguments: [
        "startsAt": .variable("startsAt"),
        "endsAt": .variable("endsAt")
      ]),
    ] }

    public var timers: [Timer?]? { __data["timers"] }

    /// Timer
    ///
    /// Parent Type: `Timers`
    public struct Timer: DirectusGraphql.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { DirectusGraphql.Objects.Timers }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", Int?.self),
        .field("endsAt", String?.self),
        .field("startsAt", String?.self),
        .field("duration", Int?.self),
        .field("totalDuration", Int?.self),
        .field("task", Task?.self),
        .field("project", Project?.self),
        .field("notes", String?.self),
      ] }

      public var id: Int? { __data["id"] }
      public var endsAt: String? { __data["endsAt"] }
      public var startsAt: String? { __data["startsAt"] }
      public var duration: Int? { __data["duration"] }
      public var totalDuration: Int? { __data["totalDuration"] }
      public var task: Task? { __data["task"] }
      public var project: Project? { __data["project"] }
      public var notes: String? { __data["notes"] }

      /// Timer.Task
      ///
      /// Parent Type: `Task`
      public struct Task: DirectusGraphql.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { DirectusGraphql.Objects.Task }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", Int?.self),
          .field("name", String?.self),
        ] }

        public var id: Int? { __data["id"] }
        public var name: String? { __data["name"] }
      }

      /// Timer.Project
      ///
      /// Parent Type: `Project`
      public struct Project: DirectusGraphql.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { DirectusGraphql.Objects.Project }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", Int?.self),
          .field("name", String?.self),
        ] }

        public var id: Int? { __data["id"] }
        public var name: String? { __data["name"] }
      }
    }
  }
}
