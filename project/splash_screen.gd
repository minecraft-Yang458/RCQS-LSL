extends Control

@onready var phase1 = $Phase1
@onready var phase2 = $Phase2
@onready var phase3 = $Phase3
@onready var fade_rect = $FadeRect

func _ready():
	# 初始化全部不可见
	phase1.modulate.a = 0
	phase2.modulate.a = 0
	phase3.modulate.a = 0
	fade_rect.modulate.a = 0
	
	# 开始执行三段式动画
	await start_sequence()

func start_sequence():
	# ---------- 第一阶段：红扳社 ----------
	await fade_in(phase1)
	await get_tree().create_timer(1.5).timeout
	await fade_out(phase1)

	# ---------- 第二阶段：Yang458's Product ----------
	await fade_in(phase2)
	await get_tree().create_timer(1.5).timeout
	await fade_out(phase2)

	# ---------- 第三阶段：Godot Engine（项目自带的 icon.svg） ----------
	await fade_in(phase3)
	await get_tree().create_timer(1.5).timeout
	await fade_out(phase3)

	# ---------- 全部结束：黑屏渐变切主菜单 ----------
	var tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 1.0, 0.8)  # 0.8秒渐变黑屏
	await tween.finished
	get_tree().change_scene_to_file("res://notice.tscn")  # 改成你的主菜单路径

# ---------- 淡入工具函数 ----------
func fade_in(node):
	var tween = create_tween()
	tween.tween_property(node, "modulate:a", 1.0, 0.5)  # 0.5秒淡入
	await tween.finished

# ---------- 淡出工具函数 ----------
func fade_out(node):
	var tween = create_tween()
	tween.tween_property(node, "modulate:a", 0.0, 0.5)  # 0.5秒淡出
	await tween.finished
