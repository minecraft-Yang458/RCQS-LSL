extends Control

var current_index = 0
const TOTAL = 5
const NEXT_SCENE_PATH = "res://tscn/level3.tscn"  # 请替换为你的实际路径

func _ready():
	# 初始化：只显示第1张（alpha=1），其余全透明（alpha=0）
	var sound = preload("res://assets/005-Rain01.ogg")
	SettingsManager.play_looping_sfx(sound)
	for i in range(TOTAL):
		var node = get_node("TextureRect" + str(i + 1))
		node.self_modulate.a = 1.0 if i == 0 else 0.0

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# 如果当前已经是第5张（索引4），点击直接进入下一场景
		SettingsManager.stop_sfx()
		var click_sound1 = preload("res://assets/上楼梯.wav")
		SettingsManager.play_sfx(click_sound1)
		if current_index == TOTAL - 1:
			SettingsManager.stop_looping_sfx()
			SettingsManager.stop_sfx()
			get_tree().change_scene_to_file(NEXT_SCENE_PATH)
			return
		
		# 否则：旧图变透明，新图变不透明
		var current_node = get_node("TextureRect" + str(current_index + 1))
		current_node.self_modulate.a = 0.0
		
		current_index += 1
		
		var next_node = get_node("TextureRect" + str(current_index + 1))
		next_node.self_modulate.a = 1.0
