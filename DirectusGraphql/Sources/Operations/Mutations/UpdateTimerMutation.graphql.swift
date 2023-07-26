// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class UpdateTimerMutation: GraphQLMutation {
  public static let operationName: String = "UpdateTimer"
  public static let document: ApolloAPI.DocumentType = .notPersisted(
    definition: .init(
      #"""
      mutation UpdateTimer($timerId: Int!, $duration: Int, $startsAt: String, $endsAt: String, $notes: String) {
        update(
          timerId: $timerId
          input: {duration: $duration, startsAt: $startsAt, endsAt: $endsAt, notes: $notes}
        ) {
          __typename
          id
          startsAt
          endsAt
          totalDuration
        }
      }
      """#
    ))

  public var timerId: Int
  public var duration: GraphQLNullable<Int>
  public var startsAt: GraphQLNullable<String>
  public var endsAt: GraphQLNullable<String>
  public var notes: GraphQLNullable<String>

  public init(
    timerId: Int,
    duration: GraphQLNullable<Int>,
    startsAt: GraphQLNullable<String>,
    endsAt: GraphQLNullable<String>,
    notes: GraphQLNullable<String>
  ) {
    self.timerId = timerId
    self.duration = duration
    self.startsAt = startsAt
    self.endsAt = endsAt
    self.notes = notes
  }

  public var __variables: Variables? { [
    "timerId": timerId,
    "duration": duration,
    "startsAt": startsAt,
    "endsAt": endsAt,
    "notes": notes
  ] }

  public struct Data: DirectusGraphql.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { DirectusGraphql.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("update", Update?.self, arguments: [
        "timerId": .variable("timerId"),
        "input": [
          "duration": .variable("duration"),
          "startsAt": .variable("startsAt"),
          "endsAt": .variable("endsAt"),
          "notes": .variable("notes")
        ]
      ]),
    ] }

    public var update: Update? { __data["update"] }

    /// Update
    ///
    /// Parent Type: `Update`
    public struct Update: DirectusGraphql.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { DirectusGraphql.Objects.Update }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", Int?.self),
        .field("startsAt", String?.self),
        .field("endsAt", String?.self),
        .field("totalDuration", Int?.self),
      ] }

      public var id: Int? { __data["id"] }
      public var startsAt: String? { __data["startsAt"] }
      public var endsAt: String? { __data["endsAt"] }
      public var totalDuration: Int? { __data["totalDuration"] }
    }
  }
}
