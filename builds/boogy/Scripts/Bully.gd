extends Node2D
@onready var tile_map = $"../TileMap"
@onready var button = $Button
var speed
@export var startingDir = Vector2i.UP

var directionRegular = Vector2.UP
var directionDash = Vector2.RIGHT
var direction
var rushSpeed
var isRushing = false
@export var normalSpeed = 50
@export var horizontalMovement: bool = false

var dashLeftRight: bool = true
### Tiles
var currentTile
var nextTile
var previousTile
var tile_dataCurrent: TileData 
var tile_dataNext: TileData
var tile_dataPrevious: TileData




# Called when the node enters the scene tree for the first time.
func _ready():
	#Sets starting Variables
	rushSpeed = 10 * normalSpeed
	speed = normalSpeed
	direction = directionRegular

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Input
	if Input.is_action_just_pressed("up"):
		isRushing = true
		speed = rushSpeed
		direction = directionDash
		
	global_position += direction * delta * speed

	checkWall()

func checkWall():
	GetTiles()
	
	if tile_dataCurrent.get_custom_data("back") == true:
		if isRushing:
			isRushing = false
			speed = normalSpeed
			global_position = tile_map.map_to_local(previousTile)
			directionDash = - directionDash
		else:
			directionRegular = - directionRegular
		direction = directionRegular
		
func GetTiles():
	var directionI = Vector2i(direction)
	
	currentTile = tile_map.local_to_map(global_position)
	nextTile = currentTile + directionI
	previousTile = currentTile - directionI
	
	tile_dataCurrent 	= tile_map.get_cell_tile_data(0,currentTile)
	tile_dataNext 		= tile_map.get_cell_tile_data(0,nextTile)
	tile_dataPrevious 	= tile_map.get_cell_tile_data(0,previousTile)

