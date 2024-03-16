class ShipModel {
  ShipModel(this.cost, this.combat, this.movement, this.capacity, this.type);
  final int cost;
  final int combat;
  final int movement;
  final int capacity;
  final ShipType type;

  @override
  operator ==(Object other) {
    if (other is ShipModel) {
      return equals(other);
    }
    return false;
  }

  equals(ShipModel other) {
    return cost == other.cost &&
        combat == other.combat &&
        movement == other.movement &&
        capacity == other.capacity &&
        type == other.type;
  }

  @override
  int get hashCode => cost.hashCode ^ combat.hashCode ^ movement.hashCode ^ capacity.hashCode ^ type.hashCode;

}

enum ShipType {
  carrier,
  cruiser,
  destroyer,
  dreadnought,
  flagship,
  fighter,
  warsun,
}
