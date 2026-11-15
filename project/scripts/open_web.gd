extends Button

func _ready():
	# 连接自身按下的信号（也可以在编辑器里手动连，但代码更直观）
	pressed.connect(_on_pressed)

func _on_pressed():
	# 点击后打开网址
	OS.shell_open("https://github.com/minecraft-Yang458/RCQS-LSL")
