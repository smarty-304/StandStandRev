extends Control

@onready var button_press_sfx = $buttonPressSFX



func _on_play_pressed():
	button_press_sfx.play()
	get_tree().change_scene_to_file("res://Scenes/GameScenes/main.tscn")

func _on_settings_pressed():
	button_press_sfx.play()
	get_tree().change_scene_to_file("res://Scenes/GameScenes/settings.tscn")

func _on_quit_pressed():
	button_press_sfx.play()
	get_tree().quit()


func _on_tutorial_pressed():
	button_press_sfx.play()
	get_tree().change_scene_to_file("res://Scenes/GameScenes/tutorial_level.tscn")


func _on_credits_pressed():
	get_tree().change_scene_to_file("res://Scenes/GameScenes/Credits.tscn")
