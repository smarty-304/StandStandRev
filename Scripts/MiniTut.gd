extends CharacterBody2D
@onready var tile_map = $"../../TileMap"
@onready var animated_sprite_2d = $MiniAnim
@onready var hit_stop = $hitStop
@onready var collision_shape_2d = $CollisionShape2D

@onready var william_scream = $william
@onready var impact_bell_1 = $impactBell1
@onready var impact_bell_2 = $impactBell2
@onready var impact_bell_3 = $impactBell3
@onready var impact_bell_4 = $impactBell4
@onready var impact_bell_5 = $impactBell5

@onready var timer = $Timer
@onready var camera_2d = $"../../Camera2D"

var randAnimation: int 
var evilBully

var nextDirection

signal iGotHit(i)

var deactivateMovement = false

# Called when the node enters the scene tree for the first time.
func _ready():
	randAnimation = randi_range(0,2)
	if randAnimation == 1:
		animated_sprite_2d.play("guy")
	elif randAnimation == 2:
		animated_sprite_2d.play("emo")
	
	if randi_range(0,1) > 0:
		animated_sprite_2d.flip_h = true
	setNexDirection()


func move(direction: Vector2):
	if deactivateMovement:
		return
	# Get cur Tile
	var currentTile: Vector2i = tile_map.local_to_map(global_position)
	#Get target Tile
	var targetTile : Vector2i = Vector2i(
		currentTile.x + direction.x,
		currentTile.y + direction.y
		)
		
	#Custome DataLayer
	var tile_data: TileData = tile_map.get_cell_tile_data(0,targetTile)
	
	if tile_data.get_custom_data("dance") == false:
		return
	#Move
	global_position = tile_map.map_to_local(targetTile)

func _on_timer_timeout():
	if nextDirection == 0:
		move(Vector2.UP)
	elif  nextDirection ==1:
		move(Vector2.DOWN)
	elif  nextDirection ==2:
		move(Vector2.LEFT)
	elif  nextDirection ==3:
		move(Vector2.RIGHT)

func _on_turn_around_timer_timeout():
	if randi_range(0,1) > 0:
		animated_sprite_2d.flip_h = not animated_sprite_2d.flip_h

func setNexDirection():
	nextDirection = randi_range(0,3)


func _on_hit_stop_timeout():
	evilBully.modulate = Color(1, 1, 1, 1)
	evilBully.speed = evilBully.rushSpeed


func _on_area_2d_body_entered(body):
	collision_shape_2d.disabled = true
	camera_2d.applyShake()
	deactivateMovement = true
	var sizeAway = create_tween()
	var flyAway = create_tween()
	flyAway.tween_property(self,"position",(position-body.position)*30 ,.5)
	sizeAway.tween_property(self,"scale",Vector2(2,2),.5)
	evilBully = body
	hit_stop.start()
	evilBully.Combo()
	evilBully.speed = 0
	evilBully.modulate = Color(0, 0, 0, 1)
	iGotHit.emit(self)


func _on_flyaway_timeout():
	queue_free()

