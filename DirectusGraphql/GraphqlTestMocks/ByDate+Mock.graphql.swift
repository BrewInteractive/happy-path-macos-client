// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import DirectusGraphql

public class ByDate: MockObject {
  public static let objectType: Object = DirectusGraphql.Objects.ByDate
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = Array<Mock<ByDate>>

  public struct MockFields {
    @Field<String>("date") public var date
    @Field<Int>("totalDuration") public var totalDuration
  }
}

public extension Mock where O == ByDate {
  convenience init(
    date: String? = nil,
    totalDuration: Int? = nil
  ) {
    self.init()
    _set(date, for: \.date)
    _set(totalDuration, for: \.totalDuration)
  }
}
