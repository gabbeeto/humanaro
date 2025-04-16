extends GameEntity

class_name Enemy

enum Direction {X,Z}


func mkDirection(type: Direction = Direction.X , amount: int = 1, isPositive: bool = true) -> Dictionary:
	return {"type": type , "amount": amount , "isPositive": isPositive}


var playerInArea: bool = false

var enemyPath: Array[Dictionary]= [
mkDirection(Direction.X, 2 ),
mkDirection(Direction.Z, 4 , false)
]


var currentMovementIndex: int = 0 

var firstGlobalPosition: Vector3
func entityStarts() -> void:
	# because position changes
	firstGlobalPosition = global_position
	currentMovementIndex = 0




var EnemyDoneAllPath: bool = false

func entityProcess(delta: float) -> void:
	var currentPath: Dictionary = enemyPath[currentMovementIndex]

	print(currentPath)
	var directionIsPositive: bool = currentPath.isPositive
	var isXAxis: bool = currentPath['type'] == Direction.X

	var enemyReachedGoal: bool = false
	
	if isXAxis and directionIsPositive:
		enemyReachedGoal =  global_position.x > (firstGlobalPosition.x + currentPath['amount']) 
		if enemyReachedGoal:
			velocity.x = 0
			addCurrentMovement()
			pass
		else:
			velocity.x += moveSpeed * delta
	elif isXAxis and not directionIsPositive:
		enemyReachedGoal =  global_position.x < (firstGlobalPosition.x - currentPath['amount'])
		if enemyReachedGoal:
			velocity.x = 0
			addCurrentMovement()
		else:
			velocity.x -= moveSpeed * delta
	#TODO: fix out of bound problem
	elif not isXAxis and directionIsPositive:
		enemyReachedGoal =  global_position.z > (firstGlobalPosition.z + currentPath['amount'])
		if enemyReachedGoal:
			velocity.z = 0
			addCurrentMovement()
		else:
			velocity.z += moveSpeed * delta
	elif not isXAxis and not directionIsPositive:
		enemyReachedGoal =  global_position.z < (firstGlobalPosition.z - currentPath['amount'])
		if enemyReachedGoal:
			velocity.z = 0
			addCurrentMovement()
		else:
			velocity.z -= moveSpeed * delta



func addCurrentMovement()	-> void:
	var alignment: int = 1
	var nextPathIsLastPath: bool =  currentMovementIndex + 1 == len(enemyPath) 
	var opositeDirectionAligntment: int = 1
	if EnemyDoneAllPath:
		alignment = -1
		nextPathIsLastPath = currentMovementIndex - 1 > 0

	if nextPathIsLastPath:
		EnemyDoneAllPath = not EnemyDoneAllPath
		opositeDirectionAligntment = -1

	currentMovementIndex += alignment * opositeDirectionAligntment





func playerExitsArea(_body:APlayer) -> void:
	playerInArea = false


func playerEntersArea(_body:APlayer) -> void:
	playerInArea = true

