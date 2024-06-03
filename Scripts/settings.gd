extends Control
@onready var buttonsfx = $buttonsfx


func _on_back_pressed():
	buttonsfx.play()
	get_tree().change_scene_to_file("res://Scenes/GameScenes/menu.tscn")
