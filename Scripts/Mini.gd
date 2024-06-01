extends CharacterBody2D
@onready var tile_map = $"../../TileMap"
@onready var animated_sprite_2d = $MiniAnim
@onready var hit_stop = $hitStop

@onready var william_scream = $william
@onready var impact_bell_1 = $impactBell1
@onready var impact_bell_2 = $impactBell2
@onready var impact_bell_3 = $impactBell3
@onready var impact_bell_4 = $impactBell4
@onready var impact_bell_5 = $impactBell5

@onready var timer = $Timer


var evilBully

var nextDirection

signal iGotHit(i)


# Called when the node enters the scene tree for the first time.
func _ready():
	if randi_range(0,1) > 0:
		animated_sprite_2d.play("guy")
	if randi_range(0,1) > 0:
		animated_sprite_2d.flip_h = true
	setNexDirection()


func move(direction: Vector2):
	
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
	queue_free()


func _on_area_2d_body_entered(body):

	evilBully = body
	hit_stop.start()
	evilBully.Combo()
	evilBully.speed = 0
	evilBully.modulate = Color(0, 0, 0, 1)
	iGotHit.emit(self)
