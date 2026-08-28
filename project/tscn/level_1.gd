extends Control

@onready var img1 = $Image1
@onready var img2 = $Image2
@onready var background = $Background
var shake_tween: Tween

func _ready():
	img1.modulate.a = 0
	img2.modulate.a = 0
	
	await show_sequence()

func show_sequence():
	# ===== 新增：开场先黑屏 1.5 秒 =====
	await get_tree().create_timer(1.5).timeout

	# 图1：淡入(0.5s) → 停留(1.5s) → 淡出(0.5s)
	await fade_in(img1)
	await get_tree().create_timer(1.5).timeout

	# 图2：淡入(0.5s) → 停留(1.5s) → 淡出(0.5s)
	img2.modulate.a = 1.0
	start_shake()
	await get_tree().create_timer(2).timeout
	

	# 黑屏转场 → 切到目标场景
	
	#get_tree().change_scene_to_file("res://MainMenu.tscn")  # 改你的路径

func fade_in(node):
	var t = create_tween()
	t.tween_property(node, "modulate:a", 1.0, 0.5)
	await t.finished

func fade_out(node):
	var t = create_tween()
	t.tween_property(node, "modulate:a", 0.0, 0.5)
	await t.finished
func start_shake():
	# 如果已有动画，先杀掉
	if shake_tween:
		shake_tween.kill()
	
	# 【关键修复】无论之前有没有，都要重新创建
	shake_tween = get_tree().create_tween()  # 用 get_tree() 更稳
	if not shake_tween:
		return  # 防万一
	
	shake_tween.set_loops()
	shake_tween.tween_method(apply_shake, 0.0, 1.0, 0.1)

func apply_shake(_value):
	# 随机偏移 ±10 像素（可调幅度）
	var offset = Vector2(randf_range(-10, 10), randf_range(-10, 10))
	background.position = offset

func stop_shake():
	if shake_tween:
		shake_tween.kill()
		shake_tween = null
		background.position = Vector2.ZERO  # 复位
