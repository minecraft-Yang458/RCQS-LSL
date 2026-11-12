extends CanvasLayer

var can_pause := true

@onready var resume_button: Button    = %ResumeButton
@onready var load_button: Button      = %LoadButton
@onready var save_button: Button      = %SaveButton
@onready var setting_button: Button   = %SettingButton
@onready var main_menu_button: Button = %MainMenuButton
@onready var quit_button: Button      = %QuitButton

func _ready() -> void:
	pause_menu.can_pause = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()
	resume_button.pressed.connect(_on_resume_pressed)
	load_button.pressed.connect(_on_load_pressed)
	save_button.pressed.connect(_on_save_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	setting_button.pressed.connect(_on_setting_pressed)

func _unhandled_input(event: InputEvent) -> void:
	if not can_pause:
		return
	if event.is_action_pressed("ui_cancel"):
		if get_tree().paused:
			resume()
		else:
			pause()
		get_viewport().set_input_as_handled()

func pause() -> void:
	get_tree().paused = true
	show()
	resume_button.grab_focus()

func resume() -> void:
	get_tree().paused = false
	hide()

func _on_resume_pressed() -> void:
	resume()

func _on_load_pressed() -> void:
	# TODO: 读档系统做好后填这里
	print("读档 —— 还没做")

func _on_save_pressed() -> void:
	# TODO: 存档系统做好后填这里
	print("存档 —— 还没做")

func _on_setting_pressed() -> void:
	# TODO: 修复跳转方式
	resume()   
	get_tree().change_scene_to_file("res://settings.tscn")
func _on_main_menu_pressed() -> void:
	resume()   
	get_tree().change_scene_to_file("res://main.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
