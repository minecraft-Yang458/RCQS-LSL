extends Node

const CONFIG_PATH = "user://settings.cfg"

# 运行时变量
var master_volume : float = 0.0      # 范围 -60 ~ 6
var is_fullscreen : bool = false
var current_lang : String = "zh-CN"  # 新增：记录当前语言

# 音频播放器
var ui_sfx_player : AudioStreamPlayer
var sfx_player: AudioStreamPlayer
var loop_sfx_player: AudioStreamPlayer

func _ready():
	# 1. 初始化各种音效播放器（挂在根节点下，避免切换场景被销毁）
	ui_sfx_player = AudioStreamPlayer.new()
	add_child(ui_sfx_player)
	
	sfx_player = AudioStreamPlayer.new()
	add_child(sfx_player)
	
	loop_sfx_player = AudioStreamPlayer.new()
	add_child(loop_sfx_player)
	
	# 2. 读取配置并应用
	load_settings()

# ---------- 保存与加载 ----------
func save_settings():
	var config = ConfigFile.new()
	config.set_value("audio", "master_volume", master_volume)
	config.set_value("display", "fullscreen", is_fullscreen)
	config.set_value("system", "language", current_lang) # 新增语言保存
	config.save(CONFIG_PATH)

func load_settings():
	var config = ConfigFile.new()
	if config.load(CONFIG_PATH) != OK:
		apply_settings()
		return
	
	master_volume = config.get_value("audio", "master_volume", 0.0)
	is_fullscreen = config.get_value("display", "fullscreen", false)
	current_lang = config.get_value("system", "language", "zh-CN")
	
	apply_settings()
	
	# 启动时同步语言包（依赖你的 LocalizationManager）
	if Engine.has_singleton("LocalizationManager") or has_node("/root/LocalizationManager"):
		get_node("/root/LocalizationManager").set_language(current_lang)

# ---------- 应用设置 ----------
func apply_settings():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), master_volume)
	
	if is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

# ---------- 播放音频功能 ----------
# 播放单次 UI 点击音效
func play_ui_sound():
	if ui_sfx_player and ui_sfx_player.stream:
		ui_sfx_player.pitch_scale = 1.0
		ui_sfx_player.play()

# 播放单次 SFX
func play_sfx(stream: AudioStream):
	if not sfx_player.playing:
		sfx_player.stream = stream
		sfx_player.pitch_scale = 1.0
		sfx_player.play()
	else:
		var temp = AudioStreamPlayer.new()
		temp.stream = stream
		temp.pitch_scale = 1.0
		add_child(temp)
		temp.play()
		temp.finished.connect(temp.queue_free)

func stop_sfx():
	if sfx_player and sfx_player.playing:
		sfx_player.stop()

# 播放循环 SFX
func play_looping_sfx(stream: AudioStream):
	loop_sfx_player.pitch_scale = 1.0
	loop_sfx_player.stream = stream
	
	if loop_sfx_player.finished.is_connected(_on_loop_sfx_finished):
		loop_sfx_player.finished.disconnect(_on_loop_sfx_finished)
	
	loop_sfx_player.finished.connect(_on_loop_sfx_finished)
	loop_sfx_player.play()

func _on_loop_sfx_finished():
	if loop_sfx_player and loop_sfx_player.playing == false:
		loop_sfx_player.play()

func stop_looping_sfx():
	if loop_sfx_player:
		loop_sfx_player.stop()
	if loop_sfx_player.finished.is_connected(_on_loop_sfx_finished):
		loop_sfx_player.finished.disconnect(_on_loop_sfx_finished)
