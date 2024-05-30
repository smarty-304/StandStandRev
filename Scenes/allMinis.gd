extends Node2D
var children = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in self.get_children():
		children.append(i)
		print(children)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
