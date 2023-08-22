// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import DirectusGraphql

public class Me: MockObject {
  public static let objectType: Object = DirectusGraphql.Objects.Me
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = Array<Mock<Me>>

  public struct MockFields {
    @Field<String>("email") public var email
  }
}

public extension Mock where O == Me {
  convenience init(
    email: String? = nil
  ) {
    self.init()
    _set(email, for: \.email)
  }
}
