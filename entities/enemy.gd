extends GameEntity

class_name Enemy

enum Direction {X,Z}


func mkDirection(type: Direction = Direction.X , amount: int = 1, isPositive: bool = true) -> Dictionary:
	return {"type": type , "amount": amount , "isPositive": isPositive}


var playerInArea: bool = false
const enemyMovement := preload("uid://cm2vrnbugmqws")

var enemyPath: Array[EnemyMovement]= [
EnemyMovement.new(GlobalEnum.EnemyDirection.X,2),
EnemyMovement.new(GlobalEnum.EnemyDirection.Z,5),
]


var currentMovementIndex: int = 0 

var firstGlobalPosition: Vector3
var pathToTravel: Array
func entityStarts() -> void:
	currentMovementIndex = 0


	# because position changes
	firstGlobalPosition = global_position

	var currentGlobal :Vector3 = firstGlobalPosition
	var pathLength: int = len(enemyPath)
	# makes the path that the enemy needs to traverse
	for index in pathLength:
		var currentPath: EnemyMovement = enemyPath[index]

		var isXAxis: bool = currentPath['type'] == Direction.X
		var isZAxis: bool = currentPath['type'] == Direction.Z


		var isPositive: bool = currentPath['isPositive'] == true

		var positiveSign: int = -1
		if isPositive:
			positiveSign = 1


		var vectorSign: Vector2
		if isXAxis:
			currentGlobal.x +=  (currentPath['amount'] * positiveSign)
			vectorSign.x = positiveSign
			vectorSign.y = 0
		elif isZAxis:
			currentGlobal.z +=  (currentPath['amount'] * positiveSign)
			vectorSign.x = 0
			vectorSign.y = positiveSign
		var pathArray: Array = [currentGlobal,vectorSign]
		pathToTravel.append(pathArray)


	# make copys so you  do not affect the original array
	var copyOfPathToTravel: Array = pathToTravel.duplicate(true)
	var secondCopyOfPathToTravel: Array = pathToTravel.duplicate(true)

	# we start the index at the element before the last one so we can decrease it later
	var index: int= pathLength -2
	# use the index to make the path in reverse so it's easier to make a movement loop
	while index > -1:

		var newPathToTravel: Array = copyOfPathToTravel[index]

		var currentPath: Vector3 = newPathToTravel[0]
		var nextPath: Vector3 = secondCopyOfPathToTravel[index +1][0]

		var newDirectionVector: Vector2
		if currentPath.x == nextPath.x:
			newDirectionVector.x = 0
		elif currentPath.x > nextPath.x:
			newDirectionVector.x = 1
		else:
			newDirectionVector.x = -1

		if currentPath.z == nextPath.z:
			newDirectionVector.y = 0
		elif currentPath.z > nextPath.z:
			newDirectionVector.y = 1
		else:
			newDirectionVector.y = -1

		newPathToTravel[1] = newDirectionVector

		pathToTravel.append(newPathToTravel)
		index -= 1



	
	# this direction is for the movement that goes to the origin/firstGlobalPosition at the end
	var firstDirection: Vector2 = pathToTravel[0][1]
	var lastDirection: Vector2
	# multiply by -1 because it goes to the other side when enemy is coming back 
	lastDirection.x = 0.0 if firstDirection.x == 0 else -1 * firstDirection.x
	lastDirection.y = 0.0 if firstDirection.x == 0 else -1 * firstDirection.y

	# add the enemy's origin as final path/destination so we can start from scratch in the next iteration
	pathToTravel.append([firstGlobalPosition, lastDirection ])






@export var enemyAsset: Node3D 
var EnemyDoneAllPath: bool = false

func entityProcess(delta: float) -> void:
	var animationPlayer: AnimationPlayer = enemyAsset.get_node("AnimationPlayer")
	animationPlayer.play("move")
	animationPlayer.speed_scale = 4

	var currentMovementContainer: Array = pathToTravel[currentMovementIndex]
	var pathToGo: Vector3 = currentMovementContainer[0]
	var direction: Vector2 = currentMovementContainer[1]

	var rotationDuration: float = .8
	# mean to change when the direction changes
	var rotationDirection: int = 0

	var enemyReachedDestination: bool
	var newVelocity: Vector3

	if direction.x == 1:
		rotationDirection= -90
		enemyReachedDestination = global_position.x > pathToGo.x
		newVelocity.x += sideMovementSpeed * delta
	elif direction.x == -1:
		rotationDirection= 90
		enemyReachedDestination = global_position.x < pathToGo.x
		newVelocity.x -= sideMovementSpeed * delta
	elif direction.y == -1:
		rotationDirection= 0
		enemyReachedDestination = global_position.z < pathToGo.z
		newVelocity.z -= sideMovementSpeed * delta
	elif direction.y == 1:
		rotationDirection= -180
		enemyReachedDestination = global_position.z > pathToGo.z
		newVelocity.z += sideMovementSpeed * delta

	if enemyReachedDestination:
		velocity.x = 0
		velocity.z = 0
		# this makes so it changes the destination/path
		increaseMovementIndex()
	else:
		var rotationTween :Tween  = create_tween()
		rotationTween.tween_property(enemyAsset,"rotation_degrees:y",rotationDirection, rotationDuration)
		rotationTween.play()
		velocity = Vector3(newVelocity.x, velocity.y, newVelocity.z)

	







func increaseMovementIndex()	-> void:
	if currentMovementIndex + 1 >= len(pathToTravel):
		currentMovementIndex = 0
	else:
		currentMovementIndex +=  1






func playerExitsArea(_body:APlayer) -> void:
	playerInArea = false


func playerEntersArea(_body:APlayer) -> void:
	playerInArea = true
