extends PointLight2D
@onready var level = $"../.."

var lightTween: Tween


# Called when the node enters the scene tree for the first time.
func _ready():
	lightTween = get_tree().create_tween()
	lightTween.tween_property(self,"transform",level.danceTileLowX,10)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
