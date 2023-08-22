// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import DirectusGraphql

public class Task: MockObject {
  public static let objectType: Object = DirectusGraphql.Objects.Task
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = Array<Mock<Task>>

  public struct MockFields {
    @Field<Int>("id") public var id
    @Field<String>("name") public var name
  }
}

public extension Mock where O == Task {
  convenience init(
    id: Int? = nil,
    name: String? = nil
  ) {
    self.init()
    _set(id, for: \.id)
    _set(name, for: \.name)
  }
}
