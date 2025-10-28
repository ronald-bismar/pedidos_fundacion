// lib/features/groups/domain/entities/group_state.dart

enum GroupState {
  deleted(0),
  active(1),
  blocked(2);
  

  final int value;
  const GroupState(this.value);

  factory GroupState.fromInt(int value) {
    switch (value) {
      case 0:
        return GroupState.deleted;
      case 1:
        return GroupState.active;
      case 2:
        return GroupState.blocked;
      default:
        return GroupState.active;
    }
  }
}