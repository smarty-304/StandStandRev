extends Node2D

@onready var impact_bell_1 = $"../MiniSounds/impactBell1"
@onready var impact_bell_2 = $"../MiniSounds/impactBell2"
@onready var impact_bell_3 = $"../MiniSounds/impactBell3"
@onready var impact_bell_4 = $"../MiniSounds/impactBell4"
@onready var impact_bell_5 = $"../MiniSounds/impactBell5"
@onready var william = $"../MiniSounds/william"
@onready var winning_timer = $"../WinningTimer"




var children = []

func _ready():
	for child in self.get_children():
		children.append(child)	

func _on_minis_i_got_hit(i):
	gotHit(i)

func _on_minis_4_i_got_hit(i):
	gotHit(i)

func _on_minis_6_i_got_hit(i):
	gotHit(i)

func _on_minis_2_i_got_hit(i):
	gotHit(i)

func gotHit(child):
		#play sound
	var randSound = randi_range(0,6)
	if randSound == 0:
		impact_bell_1.play()
	elif randSound == 1:
		impact_bell_2.play()
	elif randSound == 2:
		impact_bell_3.play()
	elif randSound == 3:
		impact_bell_4.play()
	elif randSound == 4:
		impact_bell_5.play()
	elif randSound == 5:
		william.play(.1)
	children.erase(child)
	if children.is_empty():
		winning()


func winning():
	winning_timer.start()
	
	


func _on_winning_timer_timeout():
	get_tree().change_scene_to_file("res://Scenes/GameScenes/Win.tscn")
