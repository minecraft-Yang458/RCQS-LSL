extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pause_menu.can_pause = false
	pause_menu.resume() 


func _exit_tree() -> void:
	pause_menu.can_pause = true
