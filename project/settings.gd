extends Button
func _ready():
	pressed.connect(_on_exit_pressed)

func _on_exit_pressed():
	# 退出游戏的硬编码核心指令
	get_tree().quit()
