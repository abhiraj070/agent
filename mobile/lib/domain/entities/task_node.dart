enum NodeState { preparing, calling, waiting, done, needsYou }

extension NodeStateLabel on NodeState {
  String get label {
    switch (this) {
      case NodeState.preparing:
        return 'Preparing';
      case NodeState.calling:
        return 'Calling';
      case NodeState.waiting:
        return 'Waiting';
      case NodeState.done:
        return 'Done';
      case NodeState.needsYou:
        return 'Needs you';
    }
  }
}

class TaskNode {
  const TaskNode({
    required this.id,
    required this.person,
    required this.action,
    required this.state,
  });

  final String id;
  final String person;
  final String action;
  final NodeState state;

  TaskNode copyWith({String? action, NodeState? state}) => TaskNode(
        id: id,
        person: person,
        action: action ?? this.action,
        state: state ?? this.state,
      );
}
