// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import DirectusGraphql

public class Query: MockObject {
  public static let objectType: Object = DirectusGraphql.Objects.Query
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = Array<Mock<Query>>

  public struct MockFields {
    @Field<Me>("me") public var me
    @Field<[Projects?]>("projects") public var projects
    @Field<Stats>("stats") public var stats
    @Field<[Tasks?]>("tasks") public var tasks
    @Field<[Timers?]>("timers") public var timers
  }
}

public extension Mock where O == Query {
  convenience init(
    me: Mock<Me>? = nil,
    projects: [Mock<Projects>?]? = nil,
    stats: Mock<Stats>? = nil,
    tasks: [Mock<Tasks>?]? = nil,
    timers: [Mock<Timers>?]? = nil
  ) {
    self.init()
    _set(me, for: \.me)
    _set(projects, for: \.projects)
    _set(stats, for: \.stats)
    _set(tasks, for: \.tasks)
    _set(timers, for: \.timers)
  }
}
