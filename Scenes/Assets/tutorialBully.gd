extends CharacterBody2D
@onready var tile_map = $"../TileMap"
@onready var level = $".."

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var rush_sound = $RushSound
@onready var sprite_2d = $Sprite2D

@export_category("Speed Values")
@export var normalSpeed = 25
var cooldownSpeedFactor = 1
@export var rushSpeedFactor =10

@export_category("Direction")
@export var horizontalMovement: bool = false 
@export var lowSide: bool = true
@export var directionDash = Vector2.RIGHT
@export var directionRegular = Vector2.UP

@export var maxDistance: float = 1980
var startingPos: float

@onready var next_scene_timer = $"../NextSceneTimer"

var speed

var direction
var rushSpeed
var isRushing = false
var isCoolDown = false
var textIsFinished= false

var nottimerstarted = true

var dashLeftRight: bool = true

signal bully_touches_smth(something)

func _ready():
	normalSpeed = 1000
	sprite_2d.visible = false
	#Sets starting Variables
	startingPos = global_position.x
	rushSpeed = 100000
	speed = normalSpeed
	direction = Vector2(1,0)
	collision_shape_2d.disabled = true


func _process(delta):
	#Input
	if (Input.is_action_just_pressed("right")) and textIsFinished:
		isRushing = true
	
	if isRushing:
		animated_sprite_2d.play("DashR")
		speed = rushSpeed
		if rush_sound.playing == false:
			rush_sound.play()
		
	
	if(global_position.x >= maxDistance):
		animated_sprite_2d.flip_h = true
		direction = -direction
		isRushing = false
		isCoolDown =true
		sprite_2d.visible = true
	
	if (isCoolDown and (global_position.x <= startingPos)):
		speed = 0
		animated_sprite_2d.play("Idle")
		animated_sprite_2d.flip_h = false
		rush_sound.playing = false
		if nottimerstarted:
			nottimerstarted = false
			next_scene_timer.start()
		
		
	
	velocity = direction * delta * speed
	move_and_slide()



func _on_tut_timer_timeout():
	textIsFinished = true
