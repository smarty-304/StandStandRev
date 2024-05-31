extends Line2D
@export var length: int = 30

var parent = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	add_point(parent.global_position)
	
	if points.size() > length:
		remove_point(0)
