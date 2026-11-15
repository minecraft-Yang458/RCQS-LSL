extends Control

# 节点绑定
@onready var btn_start = $Button_start
@onready var btn_load = $Button_s
@onready var btn_settings = $Button_settings
@onready var btn_exit = $Button_exit

func _ready() -> void:
	
	pause_menu.can_pause = false
	pause_menu.resume()
	
	refresh_button_text()
	LocalizationManager.language_changed.connect(refresh_button_text)
	
	btn_start.pressed.connect(_on_start_pressed)
	btn_settings.pressed.connect(_on_settings_pressed)
	btn_exit.pressed.connect(_on_exit_pressed)
	
	btn_load.disabled = true 

func _exit_tree() -> void:
	pause_menu.can_pause = true

# 刷新按钮文字
func refresh_button_text():
	btn_start.text = LocalizationManager.tr_text("UI_START")
	btn_load.text = LocalizationManager.tr_text("UI_LOAD")
	btn_settings.text = LocalizationManager.tr_text("UI_SETTINGS")
	btn_exit.text = LocalizationManager.tr_text("UI_EXIT")

# 按钮跳转逻辑
func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/place.tscn")

func _on_settings_pressed():
	get_tree().change_scene_to_file("res://scenes/settings.tscn")

func _on_exit_pressed():
	get_tree().quit()
