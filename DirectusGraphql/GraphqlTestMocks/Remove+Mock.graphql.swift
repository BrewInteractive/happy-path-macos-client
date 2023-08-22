// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import DirectusGraphql

public class Remove: MockObject {
  public static let objectType: Object = DirectusGraphql.Objects.Remove
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = Array<Mock<Remove>>

  public struct MockFields {
    @Field<Int>("id") public var id
  }
}

public extension Mock where O == Remove {
  convenience init(
    id: Int? = nil
  ) {
    self.init()
    _set(id, for: \.id)
  }
}
