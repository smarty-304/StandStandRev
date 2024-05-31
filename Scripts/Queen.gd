extends CharacterBody2D
@onready var level = $".."
@onready var timer = $Timer

var direction
@export var speed = 20
@export var topX: int = 6
@export var topY: int = 6
@export var safetyMargin = .5
var pastDirection

signal queenTouch(body)


func _ready():
	setRandomDir()

func _process(_delta):
	checkWallAndDirection()
	velocity = direction * speed
	move_and_slide()

func checkWallAndDirection():
	
	#TOP Wall
	if global_position.y <= level.GetGlobalPosFromTileValue(level.danceTileLowY)+safetyMargin:
		print("TOPWALL")
		direction = Vector2(direction.x,-direction.y)
		return true
	
	#Bottom Wall
	if global_position.y >= level.GetGlobalPosFromTileValue(level.danceTileMaxY)-safetyMargin:
		print("BOTTOM WALL")
		direction = Vector2(direction.x,-direction.y)
	#Left Wall
	if global_position.x <= level.GetGlobalPosFromTileValue(level.danceTileLowX)+safetyMargin:
		print("Left Wall")
		direction = Vector2(-direction.x,direction.y)
	
	#Right Wall
	if global_position.x >= level.GetGlobalPosFromTileValue(level.danceTileMaxX)-safetyMargin:
		print("Wall Mart")
		direction = Vector2(-direction.x,direction.y)
	
func setRandomDir():
	direction = Vector2(randf_range(-1,1), randf_range(-1,1))

func _on_area_2d_body_entered(body):
	queenTouch.emit(body)
