// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import DirectusGraphql

public class Update: MockObject {
  public static let objectType: Object = DirectusGraphql.Objects.Update
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = Array<Mock<Update>>

  public struct MockFields {
    @Field<String>("endsAt") public var endsAt
    @Field<Int>("id") public var id
    @Field<String>("startsAt") public var startsAt
    @Field<Int>("totalDuration") public var totalDuration
  }
}

public extension Mock where O == Update {
  convenience init(
    endsAt: String? = nil,
    id: Int? = nil,
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
