// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import DirectusGraphql

public class Mutation: MockObject {
  public static let objectType: Object = DirectusGraphql.Objects.Mutation
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = Array<Mock<Mutation>>

  public struct MockFields {
    @Field<Log>("log") public var log
    @Field<Remove>("remove") public var remove
    @Field<Restart>("restart") public var restart
    @Field<Start>("start") public var start
    @Field<Stop>("stop") public var stop
    @Field<Update>("update") public var update
  }
}

public extension Mock where O == Mutation {
  convenience init(
    log: Mock<Log>? = nil,
    remove: Mock<Remove>? = nil,
    restart: Mock<Restart>? = nil,
    start: Mock<Start>? = nil,
    stop: Mock<Stop>? = nil,
    update: Mock<Update>? = nil
  ) {
    self.init()
    _set(log, for: \.log)
    _set(remove, for: \.remove)
    _set(restart, for: \.restart)
    _set(start, for: \.start)
    _set(stop, for: \.stop)
    _set(update, for: \.update)
  }
}
