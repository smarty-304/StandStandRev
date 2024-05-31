extends CharacterBody2D
@onready var tile_map = $"../../TileMap"
@onready var level = $"../.."

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var rush_sound = $RushSound

@export_category("Speed Values")
@export var normalSpeed = 75
var cooldownSpeedFactor = 1
@export var rushSpeedFactor =5

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
	rushSpeed = rushSpeedFactor * normalSpeed
	speed = normalSpeed
	direction = directionRegular
	collision_shape_2d.disabled = true

func _process(_delta):
	#Input
	if (Input.is_action_just_pressed("right") and 	not( isRushing or isCoolDown)and (not horizontalMovement and lowSide)) or (
		Input.is_action_just_pressed("left") and 	not( isRushing or isCoolDown)and (not horizontalMovement and not lowSide)) or (
		Input.is_action_just_pressed("down") and 		not( isRushing or isCoolDown)and (horizontalMovement and lowSide)) or (
		Input.is_action_just_pressed("up") and 	not( isRushing or isCoolDown)and (horizontalMovement and not lowSide)):
		isRushing = true
		collision_shape_2d.disabled = false
		speed = rushSpeed
		directionRegular = direction
		direction = directionDash
		rush_sound.play()
		
		
		
		#play Dash Animation
		if directionDash == Vector2.DOWN:
			animated_sprite_2d.play("DashD")
		elif directionDash == Vector2.UP:
			animated_sprite_2d.play("DashUp")
		elif directionDash == Vector2.RIGHT:
			animated_sprite_2d.play("DashR")
		elif directionDash == Vector2.LEFT:
			animated_sprite_2d.play("DashR")
	
	if checkWall():
		if isRushing: #goto Cooldown
			isRushing = false
			collision_shape_2d.disabled = true
			rush_sound.stop()
			coolDown()
		elif isCoolDown:
			coolUp()
		else:
			direction= - direction
			if horizontalMovement:
				animated_sprite_2d.flip_h = not animated_sprite_2d.flip_h
	velocity = direction * speed
	move_and_slide()

func checkWall(): ##and apply animation
	
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
				if global_position.y >= level.GetGlobalPosFromTileValue(level.secTileMaxY):
					return true
		else: #idleState
			if global_position.x <= level.GetGlobalPosFromTileValue(level.danceTileLowX) or global_position.x >= level.GetGlobalPosFromTileValue(level.danceTileMaxX):
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
			if global_position.y <= level.GetGlobalPosFromTileValue(level.danceTileLowY) or global_position.y >= level.GetGlobalPosFromTileValue(level.danceTileMaxY):
				return true
		return false


func _on_area_2d_body_entered(body):
	bully_touches_smth.emit(body)
	
func coolDown():
	isCoolDown = true
	direction = -directionDash
	speed = cooldownSpeedFactor * normalSpeed
	animated_sprite_2d.modulate = Color8(104,13,45,175)
	collision_shape_2d.disabled = true
	animated_sprite_2d.play("Idle")
	if not horizontalMovement:
		animated_sprite_2d.flip_h = not animated_sprite_2d.flip_h
	
	
func coolUp():
	isCoolDown = false
	direction = directionRegular
	speed = normalSpeed
	animated_sprite_2d.modulate = Color8(255,255,255,255)
	collision_shape_2d.disabled = false
	if not horizontalMovement:
		animated_sprite_2d.flip_h = not animated_sprite_2d.flip_h

	
	
	
	
	
	
	
	
