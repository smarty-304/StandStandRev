extends Line2D
@onready var queen = $Queen

var max_length = 1000

var queue : Array

func _process(delta):
	var pos = get_parent().position

	
	queue.push_front(pos)

	if queue.size() > max_length:
		queue.pop_back()
	
	clear_points()
	
	for points in queue:
		add_point(points)
