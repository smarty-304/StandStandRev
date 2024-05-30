extends Node2D
@onready var tile_map = $TileMap

var danceTiles = []
var secTiles = []
var backTiles = []

var danceTileMaxX
var danceTileMaxY
var danceTileLowX
var danceTileLowY

var secTileMaxX
var secTileMaxY
var secTileLowX
var secTileLowY

var backTileMaxX
var backTileMaxY
var backTileLowX
var backTileLowY


# Called when the node enters the scene tree for the first time.
func _ready():
	
# Get Tile Arrays
	for tile in tile_map.get_used_cells(0):
		if tile_map.get_cell_tile_data(0,tile).get_custom_data("dance"):
			danceTiles.append(tile)
		elif tile_map.get_cell_tile_data(0,tile).get_custom_data("security"):
			secTiles.append(tile)
		elif tile_map.get_cell_tile_data(0,tile).get_custom_data("back"):
			backTiles.append(tile)

# Get max, low X and Y Values
	danceTileMaxX = GetExtremeCoords(true,true,danceTiles)
	danceTileMaxY = GetExtremeCoords(true,false,danceTiles)
	danceTileLowX = GetExtremeCoords(false,true,danceTiles)
	danceTileLowY = GetExtremeCoords(false,false,danceTiles)
	
	secTileMaxX = GetExtremeCoords(true,true,secTiles)
	secTileMaxY = GetExtremeCoords(true,false,secTiles)
	secTileLowX = GetExtremeCoords(false,true,secTiles)
	secTileLowY = GetExtremeCoords(false,false,secTiles)
	
	backTileMaxX = GetExtremeCoords(true,true,backTiles)
	backTileMaxY = GetExtremeCoords(true,false,backTiles)
	backTileLowX = GetExtremeCoords(false,true,backTiles)
	backTileLowY = GetExtremeCoords(false,false,backTiles)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Restart"):
		get_tree().reload_current_scene()

func GetExtremeCoords(max,x,array):
	var xtremeValue
	var currentValue
	if max:
		if x:
			for element in array:
				currentValue = element.x
				if xtremeValue ==null:
					xtremeValue = currentValue
				else:
					if currentValue > xtremeValue:
						xtremeValue = currentValue
			return xtremeValue
		else:
			for element in array:
				currentValue = element.y
				if xtremeValue ==null:
					xtremeValue = currentValue
				else:
					if currentValue > xtremeValue:
						xtremeValue = currentValue
			return xtremeValue
	else:
		if x:
			for element in array:
				currentValue = element.x
				if xtremeValue ==null:
					xtremeValue = currentValue
				else:
					if currentValue < xtremeValue:
						xtremeValue = currentValue
			return xtremeValue
		else:
			for element in array:
				currentValue = element.y
				if xtremeValue ==null:
					xtremeValue = currentValue
				else:
					if currentValue < xtremeValue:
						xtremeValue = currentValue
			return xtremeValue
		
func GetGlobalPosFromTileValue(value):
	return tile_map.map_to_local(Vector2i(value,value)).x


func _on_minis_3_i_got_hit():
	pass # Replace with function body.


func _on_queen_queen_touch(body):
	print("you Loose")
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
