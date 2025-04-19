extends Node

class_name EnemyMovement


@export var type: GlobalEnum.EnemyDirection
@export var amount: int
@export var isPositive: bool

func _init(cType: GlobalEnum.EnemyDirection = GlobalEnum.EnemyDirection.X , cAmount: int = 1, cIsPositive: bool = true) -> void:
	type = cType
	amount = cAmount
	isPositive = cIsPositive
