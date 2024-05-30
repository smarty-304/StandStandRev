extends Node2D
@onready var tile_map = $"../TileMap"
@onready var timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("up"):
		move(Vector2.UP)
	elif Input.is_action_just_pressed("down"):
		move(Vector2.DOWN)
	elif Input.is_action_just_pressed("left"):
		move(Vector2.LEFT)
	elif Input.is_action_just_pressed("right"):
		move(Vector2.RIGHT)

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
	var randomDir = randi_range(0,3)
	if randomDir == 0:
		move(Vector2.UP)
	elif  randomDir ==1:
		move(Vector2.DOWN)
	elif  randomDir ==2:
		move(Vector2.LEFT)
	elif  randomDir ==3:
		move(Vector2.RIGHT)
		


func _on_bully_body_entered(body):
	body.queue_free()
	pass # Replace with function body.
