extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	# 允许接收输入
	set_process_input(true)

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		get_tree().change_scene_to_file("res://tscn/d1.tscn")
