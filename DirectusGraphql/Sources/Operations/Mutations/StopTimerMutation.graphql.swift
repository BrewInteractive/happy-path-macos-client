// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class StopTimerMutation: GraphQLMutation {
  public static let operationName: String = "StopTimer"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation StopTimer($timerId: Int!) { stop(timerId: $timerId) { __typename id startsAt endsAt totalDuration } }"#
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
      .field("stop", Stop?.self, arguments: ["timerId": .variable("timerId")]),
    ] }

    public var stop: Stop? { __data["stop"] }

    /// Stop
    ///
    /// Parent Type: `Stop`
    public struct Stop: DirectusGraphql.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { DirectusGraphql.Objects.Stop }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", String?.self),
        .field("startsAt", String?.self),
        .field("endsAt", String?.self),
        .field("totalDuration", Int?.self),
      ] }

      public var id: String? { __data["id"] }
      public var startsAt: String? { __data["startsAt"] }
      public var endsAt: String? { __data["endsAt"] }
      public var totalDuration: Int? { __data["totalDuration"] }
    }
  }
}
