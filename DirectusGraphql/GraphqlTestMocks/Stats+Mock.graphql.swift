// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import DirectusGraphql

public class Stats: MockObject {
  public static let objectType: Object = DirectusGraphql.Objects.Stats
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = Array<Mock<Stats>>

  public struct MockFields {
    @Field<[ByDate?]>("byDate") public var byDate
    @Field<[ByInterval?]>("byInterval") public var byInterval
  }
}

public extension Mock where O == Stats {
  convenience init(
    byDate: [Mock<ByDate>?]? = nil,
    byInterval: [Mock<ByInterval>?]? = nil
  ) {
    self.init()
    _set(byDate, for: \.byDate)
    _set(byInterval, for: \.byInterval)
  }
}
