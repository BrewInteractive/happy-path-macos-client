// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import DirectusGraphql

public class Start: MockObject {
  public static let objectType: Object = DirectusGraphql.Objects.Start
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = Array<Mock<Start>>

  public struct MockFields {
    @Field<Int>("duration") public var duration
    @Field<String>("endsAt") public var endsAt
    @Field<String>("id") public var id
    @Field<String>("startsAt") public var startsAt
  }
}

public extension Mock where O == Start {
  convenience init(
    duration: Int? = nil,
    endsAt: String? = nil,
    id: String? = nil,
    startsAt: String? = nil
  ) {
    self.init()
    _set(duration, for: \.duration)
    _set(endsAt, for: \.endsAt)
    _set(id, for: \.id)
    _set(startsAt, for: \.startsAt)
  }
}
