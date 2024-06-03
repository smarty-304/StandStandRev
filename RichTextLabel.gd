extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	visible_ratio = 0
	showTutorialText()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func showTutorialText():
	var ratio = create_tween()
	ratio.tween_property(self,"visible_ratio",1 ,4)
	
