extends CharacterBody2D
@onready var tile_map = $"../TileMap"
@onready var timer = $Timer
var direction
@export var speed = 20
@export var topX: int = 6
var bottomX
@export var topY: int = 6
var bottomY
var pastDirection

signal queenTouch(body)



# Called when the node enters the scene tree for the first time.
func _ready():
	pastDirection = direction
	bottomX = -1
	bottomY = -1
	
	
	#get Top && Bottom Values
	
	setRandomDir()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if Input.is_action_just_pressed("up"):
		#move(Vector2.UP)
	#elif Input.is_action_just_pressed("down"):
		#move(Vector2.DOWN)
	#elif Input.is_action_just_pressed("left"):
		#move(Vector2.LEFT)
	#elif Input.is_action_just_pressed("right"):
		#move(Vector2.RIGHT)
	move()
	velocity = direction * speed
	move_and_slide()
	
	if(pastDirection != direction):
		pastDirection = direction
	
	
	

func move(): #direction: Vector2
	#if speed ==0:
		#return
	## Get cur Tile
	#var currentTile: Vector2i = tile_map.local_to_map(global_position)
	##Get target Tile
	#var targetTile : Vector2i = Vector2i(
		#currentTile.x + direction.x,
		#currentTile.y + direction.y
		#)
		#
	##Custome DataLayer
	#var tile_data: TileData = tile_map.get_cell_tile_data(0,targetTile)
	#
	#if tile_data.get_custom_data("dance") == false:
		#return
	##Move
	#global_position = tile_map.map_to_local(targetTile)
	
	#get current tile
	var currentTile: Vector2i = tile_map.local_to_map(global_position)
	
	#var nextTile = currentTile + Vector2i(direction)
	
	var tile_data: TileData = tile_map.get_cell_tile_data(0,currentTile)
	if tile_data.get_custom_data("dance") == false:
		if currentTile.x <= bottomX or currentTile.x >= topX:
			direction.x = -direction.x
		if currentTile.y <= bottomY or currentTile.y >= topY:
			direction.y = -direction.y
		#global_position += direction * (Vector2.ONE * 5)


#func _on_timer_timeout():
	#var randomDir = randi_range(0,3)
	#if randomDir == 0:
		#move(Vector2.UP)
	#elif  randomDir ==1:
		#move(Vector2.DOWN)
	#elif  randomDir ==2:
		#move(Vector2.LEFT)
	#elif  randomDir ==3:
		#move(Vector2.RIGHT)
		
func setRandomDir():
	direction = Vector2(randf_range(-1,1), randf_range(-1,1))


func _on_bully_body_entered(body):
	#Game Over Stuff
	get_tree().quit()
	pass # Replace with function body.


func _on_area_2d_body_entered(body):
	queenTouch.emit(body)
