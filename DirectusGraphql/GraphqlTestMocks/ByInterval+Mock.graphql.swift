// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import DirectusGraphql

public class ByInterval: MockObject {
  public static let objectType: Object = DirectusGraphql.Objects.ByInterval
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = Array<Mock<ByInterval>>

  public struct MockFields {
    @Field<String>("endsAt") public var endsAt
    @Field<String>("startsAt") public var startsAt
    @Field<Int>("totalDuration") public var totalDuration
    @Field<String>("type") public var type
  }
}

public extension Mock where O == ByInterval {
  convenience init(
    endsAt: String? = nil,
    startsAt: String? = nil,
    totalDuration: Int? = nil,
    type: String? = nil
  ) {
    self.init()
    _set(endsAt, for: \.endsAt)
    _set(startsAt, for: \.startsAt)
    _set(totalDuration, for: \.totalDuration)
    _set(type, for: \.type)
  }
}
