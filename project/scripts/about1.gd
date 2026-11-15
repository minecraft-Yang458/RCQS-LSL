extends Control

# ================= 节点绑定 =================
# ⚠️ 请根据你左侧的场景树，核对下面的节点名字！
@onready var lbl_credits = $Label               # 左侧那一大坨演职人员表
@onready var lbl_copyright = $Label2   # 右上角红色的版权信息（请确认你的节点名）

# 底部的三个按钮
@onready var btn_back = $Button                 # 返回按钮
@onready var btn_license = $Button3             # GPLv3原文按钮
@onready var btn_repo = $Button2               # 项目仓库按钮

# 注意：右侧那个 ScrollContainer 里的 GPLv3 文本（Label2），咱们不碰它，让它永远保持原版英文。

func _ready():
	pause_menu.can_pause = false
	pause_menu.resume() 
	# 1. 首次进入时，刷新文本
	refresh_ui_text()
	
	# 2. 监听全局语言切换信号
	LocalizationManager.language_changed.connect(refresh_ui_text)

# ================= 核心：UI 文本多语言刷新 =================
func refresh_ui_text():
	# 底部 UI 按钮
	btn_back.text = LocalizationManager.tr_text("UI_BACK")
	btn_license.text = LocalizationManager.tr_text("UI_LICENSE_BTN")
	btn_repo.text = LocalizationManager.tr_text("UI_REPO_BTN")
	
	# 左侧演职人员表（直接用 \n 强行塞入）
	lbl_credits.text = LocalizationManager.tr_text("ABOUT_CREDITS")
	
	# 右上角版权信息
	if lbl_copyright:
		lbl_copyright.text = LocalizationManager.tr_text("ABOUT_COPYRIGHT")

func _exit_tree() -> void:
	pause_menu.can_pause = true
