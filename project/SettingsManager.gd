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
	
	# 调用初始化函数（注意：现在这个函数是独立定义的，不是嵌套在 _ready 里）

# ---------- 【修复】UI 音效初始化（独立函数，不再嵌套） ----------


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
# SettingsManager.gd 新增部分

# 循环音效专用播放器（区别于 BGM 和单次 SFX）
var loop_sfx_player: AudioStreamPlayer

# ---------- 开始循环播放音效 ----------
func play_looping_sfx(stream: AudioStream):
	# 1. 如果播放器不存在，创建它
	if not loop_sfx_player:
		loop_sfx_player = AudioStreamPlayer.new()
		loop_sfx_player.bus = "Master"  # 走主总线，受音量滑块控制
		add_child(loop_sfx_player)
	
	# 2. 重置音高，避免之前踩过的“音高变异”坑
	loop_sfx_player.pitch_scale = 1.0
	
	# 3. 更换音效文件
	loop_sfx_player.stream = stream
	
	# 4. 【重要】先断开旧的 finished 连接，防止重复连接导致多次触发
	if loop_sfx_player.finished.is_connected(_on_loop_sfx_finished):
		loop_sfx_player.finished.disconnect(_on_loop_sfx_finished)
	
	# 5. 连接循环信号
	loop_sfx_player.finished.connect(_on_loop_sfx_finished)
	
	# 6. 开始播放
	loop_sfx_player.play()

# ---------- 循环回调（内部自动循环） ----------
func _on_loop_sfx_finished():
	if loop_sfx_player and loop_sfx_player.playing == false:
		loop_sfx_player.play()

# ---------- 停止循环播放音效 ----------
func stop_looping_sfx():
	if loop_sfx_player:
		# 停止播放
		loop_sfx_player.stop()
		# 断开信号，防止下次重新播放时残留旧连接
	if loop_sfx_player.finished.is_connected(_on_loop_sfx_finished):
		loop_sfx_player.finished.disconnect(_on_loop_sfx_finished)

# ---------- 可选：判断是否正在循环播放 ----------
func is_looping_sfx_playing() -> bool:
	return loop_sfx_player and loop_sfx_player.playing
