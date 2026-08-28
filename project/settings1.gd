extends Control

@onready var master_slider = $MasterSlider
@onready var fullscreen_check = $FullscreenCheck

func _ready():
	# 从管理器读取当前值并更新 UI
	master_slider.value = SettingsManager.master_volume
	fullscreen_check.button_pressed = SettingsManager.is_fullscreen
	
	# 连接信号（硬编码）
	master_slider.value_changed.connect(_on_master_volume_changed)
	fullscreen_check.toggled.connect(_on_fullscreen_toggled)

# ---------- 音量变化 ----------
func _on_master_volume_changed(value: float):
	SettingsManager.master_volume = value
	# 实时生效
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
	# 自动保存
	SettingsManager.save_settings()

# ---------- 全屏切换 ----------
func _on_fullscreen_toggled(pressed: bool):
	print("全屏按钮被点击了，状态：", pressed)
	SettingsManager.is_fullscreen = pressed
	if pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	SettingsManager.save_settings()
