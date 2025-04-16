class_name GameEntity
extends CharacterBody3D



@export var moveSpeed: float = 200

@export var JumpHeight : float = 1
@export var JumpTimeToPeak : float = 1
@export var JumpTimeToDescent : float = 1


var jumpVelocity : float
var jumpGravity : float 
var fallGravity : float 
func _ready() -> void:
	jumpVelocity = ((2.0 * JumpHeight) / JumpTimeToPeak)
	jumpGravity = ((-2.0 * JumpHeight) / (JumpTimeToPeak * JumpTimeToPeak))
	fallGravity = ((-2.0 * JumpHeight) / (JumpTimeToDescent * JumpTimeToDescent))




func entityProcess(_delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	handleGravity(delta)
	entityProcess(delta)
	move_and_slide()

func handleGravity(delta: float) -> void:
	velocity.y += getGravity() * delta

func getGravity() -> float:
	return jumpGravity if velocity.y < 0.0 else fallGravity

func jump() -> void:
	velocity.y = jumpVelocity
