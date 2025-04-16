extends GameEntity


func entityProcess(delta: float) -> void:
	var playerIsJumping: bool = is_on_floor() and Input.is_action_pressed("jump")
	if playerIsJumping:
			jump()
	handleSideMovement(delta)

func handleSideMovement(delta: float) -> void:
	var playerPressedSideMovement: Vector2 = Input.get_vector("left","right","up","down")
	velocity = Vector3(playerPressedSideMovement.x * moveSpeed * delta, velocity.y, playerPressedSideMovement.y * moveSpeed * delta )
