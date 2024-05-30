extends CharacterBody2D
@onready var tile_map = $"../TileMap"
@onready var button = $Button
@onready var level = $".."
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var collision_shape_2d = $CollisionShape2D

@export_category("Speed Values")
@export var normalSpeed = 75
@export var cooldownSpeedFactor = 0.1

@export_category("Direction")
@export var horizontalMovement: bool = false 
@export var lowSide: bool = true
@export var directionDash = Vector2.RIGHT
@export var directionRegular = Vector2.UP

var speed

var direction
var rushSpeed
var isRushing = false
var isCoolDown = false

var dashLeftRight: bool = true

signal bully_touches_smth(something)

func _ready():
	#Sets starting Variables
	rushSpeed = 10 * normalSpeed
	speed = normalSpeed
	direction = directionRegular

func _process(_delta):
	#Input
	if (Input.is_action_just_pressed("left") and 	not( isRushing or isCoolDown)and (not horizontalMovement and lowSide)) or (
		Input.is_action_just_pressed("right") and 	not( isRushing or isCoolDown)and (not horizontalMovement and not lowSide)) or (
		Input.is_action_just_pressed("up") and 		not( isRushing or isCoolDown)and (horizontalMovement and lowSide)) or (
		Input.is_action_just_pressed("down") and 	not( isRushing or isCoolDown)and (horizontalMovement and not lowSide)):
		isRushing = true
		speed = rushSpeed
		directionRegular = direction
		direction = directionDash
	
	if checkWall():
		if isRushing:
			isRushing = false
			coolDown()
		elif isCoolDown:
			coolUp()
		else:
			direction= - direction
	velocity = direction * speed
	move_and_slide()

func checkWall():
	
	if horizontalMovement:
		if isRushing:
			if lowSide:
				if global_position.y >= level.GetGlobalPosFromTileValue(level.danceTileMaxY):
					return true
			else:
				if global_position.y <= level.GetGlobalPosFromTileValue(level.danceTileLowY):
					return true
			return false
		elif isCoolDown:
			if lowSide:
				if global_position.y <= level.GetGlobalPosFromTileValue(level.secTileLowY):
					return true
			else:
				print("bullyDown says hi")
				if global_position.y >= level.GetGlobalPosFromTileValue(level.secTileMaxY):
					return true
		else: #idleState
			if global_position.x <= level.GetGlobalPosFromTileValue(level.secTileLowX) or global_position.x >= level.GetGlobalPosFromTileValue(level.secTileMaxX):
				return true
		return false
		
	else:
		if isRushing:
			if lowSide:
				if global_position.x >= level.GetGlobalPosFromTileValue(level.danceTileMaxX):
					return true
			else:
				if global_position.x <= level.GetGlobalPosFromTileValue(level.danceTileLowX):
					return true
			return false
		elif isCoolDown:
			if lowSide:
				if global_position.x <= level.GetGlobalPosFromTileValue(level.secTileLowX):
					return true
			else:
				if global_position.x >= level.GetGlobalPosFromTileValue(level.secTileMaxX):
					return true
			return false
		else: #idle State
			if global_position.y <= level.GetGlobalPosFromTileValue(level.secTileLowY) or global_position.y >= level.GetGlobalPosFromTileValue(level.secTileMaxY):
				return true
		return false


func _on_area_2d_body_entered(body):
	bully_touches_smth.emit(body)
	
func coolDown():
	isCoolDown = true
	direction = -directionDash
	speed = cooldownSpeedFactor * normalSpeed
	animated_sprite_2d.modulate = Color8(104,13,45,255)
	collision_shape_2d.disabled = true
	
func coolUp():
	isCoolDown = false
	direction = directionRegular
	speed = normalSpeed
	animated_sprite_2d.modulate = Color8(255,255,255,255)
	collision_shape_2d.disabled = false
	
	
	
	
	
	
	
	
	
	
	
