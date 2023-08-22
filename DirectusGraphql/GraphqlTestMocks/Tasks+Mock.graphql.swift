// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import DirectusGraphql

public class Tasks: MockObject {
  public static let objectType: Object = DirectusGraphql.Objects.Tasks
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = Array<Mock<Tasks>>

  public struct MockFields {
    @Field<String>("id") public var id
    @Field<String>("taskName") public var taskName
  }
}

public extension Mock where O == Tasks {
  convenience init(
    id: String? = nil,
    taskName: String? = nil
  ) {
    self.init()
    _set(id, for: \.id)
    _set(taskName, for: \.taskName)
  }
}
