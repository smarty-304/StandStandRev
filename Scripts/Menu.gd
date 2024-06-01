extends Control

@onready var button_press_sfx = $buttonPressSFX



func _on_play_pressed():
	button_press_sfx.play()
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

func _on_settings_pressed():
	button_press_sfx.play()
	get_tree().change_scene_to_file("res://Scenes/settings.tscn")

func _on_quit_pressed():
	button_press_sfx.play()
	get_tree().quit()
