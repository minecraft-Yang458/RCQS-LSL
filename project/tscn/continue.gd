extends Button
func _ready():
	pressed.connect(_on_button_pressed)

func _on_button_pressed():
	# 把 "res://场景文件夹/目标场景.tscn" 替换成你的真实路径
	SettingsManager.stop_sfx()
	get_tree().change_scene_to_file("res://tscn/level2.tscn")
