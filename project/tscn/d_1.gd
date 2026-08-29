extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var click_sound = preload("res://assets/上楼梯.wav")
	var click_suond2 = preload("res://assets/005-Rain01.ogg")
	SettingsManager.play_sfx(click_sound)
	SettingsManager.play_sfx(click_suond2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
