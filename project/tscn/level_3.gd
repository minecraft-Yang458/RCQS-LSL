extends Control

@onready var my_label = $Label
@onready var my_button = $Button

# 计数器：记录点击次数
var click_count = 0

func _ready():
	# 连接按钮信号（或者你在编辑器里手动连也行）
	my_button.pressed.connect(_on_button_clicked)
	
func _on_button_clicked():
	click_count += 1  # 每次点击加 1

	if click_count == 1:
		# 第一次点击：修改 Label 文字
		var dianhuo = preload("res://assets/audio/Switch01.ogg")
		var dianhuo1 = preload("res://assets/audio/Switch02.ogg")
		SettingsManager.play_sfx(dianhuo)
		await  get_tree().create_timer(0.5).timeout
		SettingsManager.play_sfx(dianhuo)
		my_label.text = "唉……今天早点睡吧……"
	elif click_count == 2:
		# 第二次点击：跳转到下一个场景（记得替换成你的场景路径）
		get_tree().change_scene_to_file("res://tscn/level4.tscn")
