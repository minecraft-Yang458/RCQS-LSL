# SettingsManager.gd
extends Node

# 配置文件硬编码路径
const CONFIG_PATH = "user://settings.cfg"

# 运行时变量（默认值）
var master_volume : float = 0.0      # 单位 dB，范围 -60 ~ 6
var is_fullscreen : bool = false
var ui_sfx_player : AudioStreamPlayer

func _ready():
	load_settings()
	setup_ui_sfx()   # 调用初始化函数（注意：现在这个函数是独立定义的，不是嵌套在 _ready 里）

# ---------- 【修复】UI 音效初始化（独立函数，不再嵌套） ----------
func setup_ui_sfx():
	ui_sfx_player = AudioStreamPlayer.new()
	# 硬编码加载音效文件（把路径换成你的真实路径）
	ui_sfx_player.stream = preload("res://click.ogg")
	# 让它也走 Master 总线，这样音量滑块能同时控制BGM和音效
	ui_sfx_player.bus = "Master"
	add_child(ui_sfx_player)

# ---------- 【修复】播放 UI 音效（独立函数，不再嵌套） ----------
func play_ui_sound():
	if ui_sfx_player and ui_sfx_player.stream:
		ui_sfx_player.pitch_scale = 1.0
		ui_sfx_player.play()
	else:
		print("警告：UI音效文件未找到或未加载")

# ---------- 保存与加载 ----------
func save_settings():
	var config = ConfigFile.new()
	config.set_value("audio", "master_volume", master_volume)
	config.set_value("display", "fullscreen", is_fullscreen)
	config.save(CONFIG_PATH)

func load_settings():
	var config = ConfigFile.new()
	if config.load(CONFIG_PATH) != OK:
		apply_settings()
		return
	
	master_volume = config.get_value("audio", "master_volume", 0.0)
	is_fullscreen = config.get_value("display", "fullscreen", false)
	apply_settings()

# ---------- 应用设置到引擎 ----------
func apply_settings():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), master_volume)
	
	if is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
# SettingsManager.gd 新增部分

var sfx_player: AudioStreamPlayer

func play_sfx(stream: AudioStream):
	# 如果播放器不存在或已播放完，就创建新的
	if not sfx_player or not sfx_player.playing:
		if not sfx_player:
			sfx_player = AudioStreamPlayer.new()
			sfx_player.bus = "Master"
			add_child(sfx_player)
		sfx_player.stream = stream
		sfx_player.pitch_scale = 1.0  # 强制音高正常
		sfx_player.play()
	else:
		# 如果正在播放，则创建临时播放器叠加
		var temp = AudioStreamPlayer.new()
		temp.bus = "Master"
		temp.stream = stream
		temp.pitch_scale = 1.0
		add_child(temp)
		temp.play()
		temp.finished.connect(temp.queue_free)  # 播完自动移除
# SettingsManager.gd

func stop_sfx():
	if sfx_player and sfx_player.playing:
		sfx_player.stop()
