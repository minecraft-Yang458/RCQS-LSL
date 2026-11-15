extends Control

# 节点绑定
@onready var master_slider: HSlider = $MasterSlider
@onready var fullscreen_check: CheckButton = $FullscreenCheck
@onready var lang_dropdown: OptionButton = $LanguageDropdown
@onready var volume_label: Label = $Label
@onready var back_button = $MenuButton # 你的返回按钮
@onready var about_button = $About # 你的关于按钮
@onready var lang: Label = $Language

# 语言列表（下拉框的选项源）
var languages = [
	{ "name": "English", "code": "en-US" },
	{ "name": "简体中文", "code": "zh-CN" },
	{ "name": "繁體中文", "code": "zh-TW" }
]

func _ready() -> void:
	# 暂停菜单处理
	pause_menu.can_pause = false
	pause_menu.resume()

	# 1. 初始化音量与全屏状态
	master_slider.value = SettingsManager.master_volume
	fullscreen_check.button_pressed = SettingsManager.is_fullscreen

	# 2. 初始化语言下拉框
	lang_dropdown.clear()
	for lang in languages:
		lang_dropdown.add_item(lang["name"])
	
	var current_code = LocalizationManager.current_lang
	for i in range(languages.size()):
		if languages[i]["code"] == current_code:
			lang_dropdown.selected = i
			break
	
	# 3. 连接信号
	master_slider.value_changed.connect(_on_master_volume_changed)
	fullscreen_check.toggled.connect(_on_fullscreen_toggled)
	lang_dropdown.item_selected.connect(_on_language_selected)
	back_button.pressed.connect(_on_back_pressed)
	
	# 4. 初始化多语言 UI，并监听语言改变信号
	refresh_ui_text()
	LocalizationManager.language_changed.connect(refresh_ui_text)

func _exit_tree() -> void:
	pause_menu.can_pause = true

# ---------- 核心：UI 文本多语言刷新 ----------
func refresh_ui_text():
	volume_label.text = LocalizationManager.tr_text("UI_SETTINGS_VOLUME")
	fullscreen_check.text = LocalizationManager.tr_text("UI_SETTINGS_FULLSCREEN")
	back_button.text = LocalizationManager.tr_text("UI_BACK")
	about_button.text = LocalizationManager.tr_text("UI_ABOUT_TEAM")
	lang.text = LocalizationManager.tr_text("UI_LANGUAGE_CHOOSE")
	# 下拉框本身的文字不用刷新，因为它是固定的语言名称

# ---------- 音量变化 ----------
func _on_master_volume_changed(value: float):
	SettingsManager.master_volume = value
	SettingsManager.apply_settings()
	SettingsManager.save_settings()

# ---------- 全屏切换 ----------
func _on_fullscreen_toggled(pressed: bool):
	SettingsManager.is_fullscreen = pressed
	SettingsManager.apply_settings()
	SettingsManager.save_settings()

# ---------- 语言切换 ----------
func _on_language_selected(index: int) -> void:
	var selected_code = languages[index]["code"]
	SettingsManager.current_lang = selected_code
	SettingsManager.save_settings()
	
	# 广播语言改变信号，触发主菜单和设置页的刷新
	LocalizationManager.set_language(selected_code)

# ---------- 返回主菜单 ----------
func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
