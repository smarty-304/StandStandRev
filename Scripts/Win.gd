extends Control

@onready var button_press = $ButtonPress
@onready var yay = $yay



func _ready():
	yay.play()

func _on_play_pressed():
	button_press.play()
	get_tree().change_scene_to_file("res://Scenes/GameScenes/main2.tscn")

func _on_settings_pressed():
	button_press.play()
	get_tree().change_scene_to_file("res://Scenes/GameScenes/settings.tscn")

func _on_quit_pressed():
	button_press.play()
	get_tree().change_scene_to_file("res://Scenes/GameScenes/menu.tscn")
