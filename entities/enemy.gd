extends GameEntity

class_name Enemy

enum Direction {X,Z}


func mkDirection(type: Direction = Direction.X , amount: int = 1, isPositive: bool = true) -> Dictionary:
	return {"type": type , "amount": amount , "isPositive": isPositive}


var playerInArea: bool = false

var enemyPath: Array[Dictionary]= [
mkDirection(Direction.X, 2 ),
mkDirection(Direction.Z, 4 , false),
mkDirection(Direction.X, 3 ),
mkDirection(Direction.Z, 5 ),
]


var currentMovementIndex: int = 0 

var firstGlobalPosition: Vector3
@export var pathToTravel: Array
func entityStarts() -> void:
	# because position changes
	firstGlobalPosition = global_position
	currentMovementIndex = 0

	var currentGlobal :Vector3 = firstGlobalPosition
	var pathLength: int = len(enemyPath)
	for index in pathLength:
		var currentPath: Dictionary = enemyPath[index]

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
			print("isXAxis")
		elif isZAxis:
			currentGlobal.z +=  (currentPath['amount'] * positiveSign)
			vectorSign.x = 0
			vectorSign.y = positiveSign
			print("isZAxis")
		var pathArray: Array = [currentGlobal,vectorSign]
		print(vectorSign)
		print(pathArray)
		pathToTravel.append(pathArray)

	var index: int= pathLength -2
	var copyOfPathToTravel: Array = pathToTravel.duplicate(true)
	while index > -1:
		var newPathToTravel: Array = copyOfPathToTravel[index]
		newPathToTravel[1].x = -1 * copyOfPathToTravel[index + 1][1].x 
		newPathToTravel[1].y = -1 * copyOfPathToTravel[index + 1][1].y 
		pathToTravel.append(newPathToTravel)
		index -= 1

	print( pathToTravel )

		# pathToTravel.append(currentPath)




var EnemyDoneAllPath: bool = false

func entityProcess(delta: float) -> void:
	pass
	# make it so enemy traverse thought the pathToTravel and use the addCurrentMovement function to add movement






func addCurrentMovement()	-> void:
	if currentMovementIndex + 1 >= len(pathToTravel):
		currentMovementIndex = 0
	else:
		currentMovementIndex +=  1






func playerExitsArea(_body:APlayer) -> void:
	playerInArea = false


func playerEntersArea(_body:APlayer) -> void:
	playerInArea = true
