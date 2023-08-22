// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import DirectusGraphql

public class Project: MockObject {
  public static let objectType: Object = DirectusGraphql.Objects.Project
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = Array<Mock<Project>>

  public struct MockFields {
    @Field<Int>("id") public var id
    @Field<String>("name") public var name
  }
}

public extension Mock where O == Project {
  convenience init(
    id: Int? = nil,
    name: String? = nil
  ) {
    self.init()
    _set(id, for: \.id)
    _set(name, for: \.name)
  }
}
