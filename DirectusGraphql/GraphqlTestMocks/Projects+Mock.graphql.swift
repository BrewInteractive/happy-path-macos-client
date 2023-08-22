// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import DirectusGraphql

public class Projects: MockObject {
  public static let objectType: Object = DirectusGraphql.Objects.Projects
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = Array<Mock<Projects>>

  public struct MockFields {
    @Field<String>("id") public var id
    @Field<String>("projectName") public var projectName
  }
}

public extension Mock where O == Projects {
  convenience init(
    id: String? = nil,
    projectName: String? = nil
  ) {
    self.init()
    _set(id, for: \.id)
    _set(projectName, for: \.projectName)
  }
}
