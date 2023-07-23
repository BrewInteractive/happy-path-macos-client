// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class StatsQuery: GraphQLQuery {
  public static let operationName: String = "Stats"
  public static let document: ApolloAPI.DocumentType = .notPersisted(
    definition: .init(
      #"""
      query Stats($date: String!) {
        stats(date: $date) {
          __typename
          byDate {
            __typename
            date
            totalDuration
          }
          byInterval {
            __typename
            type
            startsAt
            endsAt
            totalDuration
          }
        }
      }
      """#
    ))

  public var date: String

  public init(date: String) {
    self.date = date
  }

  public var __variables: Variables? { ["date": date] }

  public struct Data: DirectusGraphql.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { DirectusGraphql.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("stats", Stats?.self, arguments: ["date": .variable("date")]),
    ] }

    public var stats: Stats? { __data["stats"] }

    /// Stats
    ///
    /// Parent Type: `Stats`
    public struct Stats: DirectusGraphql.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { DirectusGraphql.Objects.Stats }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("byDate", [ByDate?]?.self),
        .field("byInterval", [ByInterval?]?.self),
      ] }

      public var byDate: [ByDate?]? { __data["byDate"] }
      public var byInterval: [ByInterval?]? { __data["byInterval"] }

      /// Stats.ByDate
      ///
      /// Parent Type: `ByDate`
      public struct ByDate: DirectusGraphql.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { DirectusGraphql.Objects.ByDate }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("date", String?.self),
          .field("totalDuration", Int?.self),
        ] }

        public var date: String? { __data["date"] }
        public var totalDuration: Int? { __data["totalDuration"] }
      }

      /// Stats.ByInterval
      ///
      /// Parent Type: `ByInterval`
      public struct ByInterval: DirectusGraphql.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { DirectusGraphql.Objects.ByInterval }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("type", String?.self),
          .field("startsAt", String?.self),
          .field("endsAt", String?.self),
          .field("totalDuration", Int?.self),
        ] }

        public var type: String? { __data["type"] }
        public var startsAt: String? { __data["startsAt"] }
        public var endsAt: String? { __data["endsAt"] }
        public var totalDuration: Int? { __data["totalDuration"] }
      }
    }
  }
}
