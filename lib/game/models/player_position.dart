import 'package:codyroby_game/game/models/game_status.dart';
import 'package:flutter/material.dart';

class EndGameException with Exception {}

enum RobyRotation { nord, est, sud, ovest }

enum CellColor {
  empty,
  yellow,
  grey,
  red;

  Color get color {
    switch (this) {
      case CellColor.empty:
        return Colors.white;
      case CellColor.red:
        return Colors.red;
      case CellColor.grey:
        return Colors.grey;
      case CellColor.yellow:
        return Colors.yellow;
    }
  }

  // String get value {
  //   switch (this) {
  //     case CellColor.empty:
  //       return 'empty';
  //     case CellColor.red:
  //       return 'red';
  //     case CellColor.grey:
  //       return 'grey';
  //     case CellColor.yellow:
  //       return 'yellow';
  //   }
  // }
}

cellColorFromString(String value) {
  switch (value) {
    case 'empty':
      return CellColor.empty;
    case 'red':
      return CellColor.red;
    case 'grey':
      return CellColor.grey;
    case 'yellow':
      return CellColor.yellow;
  }
}

class PlayerPosition {
  final int x;
  final int y;
  final RobyRotation rotation;

  PlayerPosition({required this.x, required this.y, required this.rotation});

  PlayerPosition.fromJson(Map<String, Object?> json)
      : this(
          x: json['x'] as int,
          y: json['y'] as int,
          rotation: RobyRotation.values[json['rotation'] as int],
        );

  Map<String, Object?> toJson() {
    return {
      'x': x,
      'y': y,
      'rotation': rotation.index,
    };
  }

  PlayerPosition moveForward() {
    switch (rotation) {
      case RobyRotation.nord:
        if (y > 0) {
          return copyWith(y: y - 1);
        }
        return this;
      case RobyRotation.sud:
        if (y < 4) {
          return copyWith(y: y + 1);
        }
        return this;
      case RobyRotation.ovest:
        if (x > 0) {
          return copyWith(x: x - 1);
        }
        return this;
      case RobyRotation.est:
        if (x < 4) {
          return copyWith(x: x + 1);
        }
        return this;
    }
    //
    // if (y == 0) {
    //   throw Exception();
    // }
    // return PlayerPosition(x: x, y: y - 1);
  }

  canMove() {
    switch (rotation) {
      case RobyRotation.nord:
        if (y > 0) {
          return true;
        }
        return false;
      case RobyRotation.sud:
        if (y < 4) {
          return true;
        }
        return false;
      case RobyRotation.ovest:
        if (x > 0) {
          return true;
        }
        return false;
      case RobyRotation.est:
        if (x < 4) {
          return true;
        }
        return false;
    }
  }

  PlayerPosition nextPosition(CellColor cellColor) {
    if (!canMove()) {
      throw EndGameException();
    }
    var tmp = this;
    switch (rotation) {
      case RobyRotation.nord:
        tmp = copyWith(y: y - 1);
        break;
      case RobyRotation.sud:
        tmp = copyWith(y: y + 1);
        break;
      case RobyRotation.ovest:
        tmp = copyWith(x: x - 1);
        break;
      case RobyRotation.est:
        tmp = copyWith(x: x + 1);
        break;
    }

    switch (cellColor) {
      case CellColor.red:
        tmp = tmp.turnRight();
        break;
      case CellColor.yellow:
        tmp = tmp.turnLeft();
        break;
      case CellColor.grey:
      case CellColor.empty:
    }

    return tmp;
    //
    // if (y == 0) {
    //   throw Exception();
    // }
    // return PlayerPosition(x: x, y: y - 1);
  }

  turnLeft() {
    switch (rotation) {
      case RobyRotation.nord:
        return copyWith(rotation: RobyRotation.ovest);
      case RobyRotation.sud:
        return copyWith(rotation: RobyRotation.est);
      case RobyRotation.ovest:
        return copyWith(rotation: RobyRotation.sud);
      case RobyRotation.est:
        return copyWith(rotation: RobyRotation.nord);
    }
  }

  turnRight() {
    switch (rotation) {
      case RobyRotation.nord:
        return copyWith(rotation: RobyRotation.est);
      case RobyRotation.sud:
        return copyWith(rotation: RobyRotation.ovest);
      case RobyRotation.ovest:
        return copyWith(rotation: RobyRotation.nord);
      case RobyRotation.est:
        return copyWith(rotation: RobyRotation.sud);
    }
  }

  @override
  String toString() {
    return 'x: $x y: $y ${enumToString(rotation)}';
  }

  PlayerPosition copyWith({int? x, int? y, RobyRotation? rotation}) {
    return PlayerPosition(
      x: x ?? this.x,
      y: y ?? this.y,
      rotation: rotation ?? this.rotation,
    );
  }
}
