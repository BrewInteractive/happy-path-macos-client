// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import DirectusGraphql

public class Stop: MockObject {
  public static let objectType: Object = DirectusGraphql.Objects.Stop
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = Array<Mock<Stop>>

  public struct MockFields {
    @Field<String>("endsAt") public var endsAt
    @Field<String>("id") public var id
    @Field<String>("startsAt") public var startsAt
    @Field<Int>("totalDuration") public var totalDuration
  }
}

public extension Mock where O == Stop {
  convenience init(
    endsAt: String? = nil,
    id: String? = nil,
    startsAt: String? = nil,
    totalDuration: Int? = nil
  ) {
    self.init()
    _set(endsAt, for: \.endsAt)
    _set(id, for: \.id)
    _set(startsAt, for: \.startsAt)
    _set(totalDuration, for: \.totalDuration)
  }
}
