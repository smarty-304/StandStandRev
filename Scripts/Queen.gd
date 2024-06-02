extends CharacterBody2D
@onready var level = $".."
@onready var timer = $Timer
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var loose = $Loose
@onready var queen = $"."
@onready var scream = $Scream


var direction
@export var speed = 20
@export var topX: int = 6
@export var topY: int = 6
@export var safetyMargin = .5
var pastDirection



signal queenTouch()


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
	if loose.time_left == 0:
		animated_sprite_2d.play("loose")
		var tweenSize = create_tween()
		var tweenRot = create_tween()
		tweenRot.tween_property(queen,"rotation", 1,2 )
		tweenSize.tween_property(queen, "scale", Vector2(8,8),2)
		scream.play()
		loose.start()

func _on_loose_timeout():
	get_tree().change_scene_to_file("res://Scenes/GameScenes/loose.tscn")
