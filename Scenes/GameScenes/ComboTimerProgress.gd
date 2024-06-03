extends ProgressBar
@onready var combo_timer = $"../ComboTimer"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	value = combo_timer.time_left * 100
