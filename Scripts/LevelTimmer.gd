extends Label
@onready var timer = $"../Timer"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var timerTimeLeftMin = str(int(timer.time_left)/60)
	var timerTimeLeftSec = int(int(timer.time_left)%60)
	var timerTimeLeftSecStr: String
	
	if timerTimeLeftSec < 10:
		timerTimeLeftSecStr = "0" + str(timerTimeLeftSec)
	else:
		timerTimeLeftSecStr = str(timerTimeLeftSec)
	
	text = timerTimeLeftMin + ":" + timerTimeLeftSecStr
