// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import DirectusGraphql

public class Restart: MockObject {
  public static let objectType: Object = DirectusGraphql.Objects.Restart
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = Array<Mock<Restart>>

  public struct MockFields {
    @Field<Int>("id") public var id
    @Field<String>("startsAt") public var startsAt
    @Field<Int>("totalDuration") public var totalDuration
  }
}

public extension Mock where O == Restart {
  convenience init(
    id: Int? = nil,
    startsAt: String? = nil,
    totalDuration: Int? = nil
  ) {
    self.init()
    _set(id, for: \.id)
    _set(startsAt, for: \.startsAt)
    _set(totalDuration, for: \.totalDuration)
  }
}
