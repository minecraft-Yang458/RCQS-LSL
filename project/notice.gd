extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pause_menu.can_pause = false
	pause_menu.resume()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _exit_tree() -> void:
	pause_menu.can_pause = true
