// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import DirectusGraphql

public class Timers: MockObject {
  public static let objectType: Object = DirectusGraphql.Objects.Timers
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = Array<Mock<Timers>>

  public struct MockFields {
    @Field<Int>("duration") public var duration
    @Field<String>("endsAt") public var endsAt
    @Field<Int>("id") public var id
    @Field<String>("notes") public var notes
    @Field<Project>("project") public var project
    @Field<String>("startsAt") public var startsAt
    @Field<Task>("task") public var task
    @Field<Int>("totalDuration") public var totalDuration
  }
}

public extension Mock where O == Timers {
  convenience init(
    duration: Int? = nil,
    endsAt: String? = nil,
    id: Int? = nil,
    notes: String? = nil,
    project: Mock<Project>? = nil,
    startsAt: String? = nil,
    task: Mock<Task>? = nil,
    totalDuration: Int? = nil
  ) {
    self.init()
    _set(duration, for: \.duration)
    _set(endsAt, for: \.endsAt)
    _set(id, for: \.id)
    _set(notes, for: \.notes)
    _set(project, for: \.project)
    _set(startsAt, for: \.startsAt)
    _set(task, for: \.task)
    _set(totalDuration, for: \.totalDuration)
  }
}
