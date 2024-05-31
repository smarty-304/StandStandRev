extends Node2D
var children = []

func _ready():
	for child in self.get_children():
		children.append(child)	

func _on_minis_i_got_hit(i):
	children.erase(i)
	if children.is_empty():
		winning()

func _on_minis_4_i_got_hit(i):
	children.erase(i)
	if children.is_empty():
		winning()

func _on_minis_6_i_got_hit(i):
	children.erase(i)
	if children.is_empty():
		winning()

func _on_minis_2_i_got_hit(i):
	children.erase(i)
	if children.is_empty():
		winning()

func winning():
	get_tree().change_scene_to_file("res://Scenes/Win.tscn")
	
