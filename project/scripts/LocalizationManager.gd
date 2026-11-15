extends Node

# 当语言发生改变时，发送此信号通知 UI 刷新
signal language_changed

const LANG_DIR = "res://lang/"
# 强制设置兜底语言为简体中文
const FALLBACK_LANG = "zh-CN" 

# 记录当前使用的语言，比如 "zh-CN" 或 "en-US"
var current_lang: String = FALLBACK_LANG 

# 存放所有翻译数据的字典，格式：{"UI_START": "开始游戏"}
var translations: Dictionary = {}

func _ready():
	# 游戏启动时，默认加载简体中文
	set_language(FALLBACK_LANG)

# 核心方法：切换语言
func set_language(lang_code: String):
	current_lang = lang_code
	translations.clear()
	
	# 第一步：无论如何，先把简体中文加载进来作为基底（兜底）
	load_lang_file(FALLBACK_LANG)
	
	# 第二步：如果目标语言不是中文，再加载目标语言，覆盖掉中文的词条
	if lang_code != FALLBACK_LANG:
		load_lang_file(lang_code)
		
	# 第三步：广播信号！告诉所有挂载了 UI 的脚本，赶紧刷新文字啦！
	print("【i18n】语言已切换至: ", lang_code)
	emit_signal("language_changed")

# 读取并解析 .lang 文件
func load_lang_file(lang_code: String):
	var path = LANG_DIR + lang_code + ".lang"
	# 如果文件不存在，直接返回，不报错（因为可能有中文兜底）
	if not FileAccess.file_exists(path):
		push_warning("【i18n】找不到语言文件: " + path + "，将使用默认语言兜底。")
		return
		
	var file = FileAccess.open(path, FileAccess.READ)
	while not file.eof_reached():
		var line = file.get_line().strip_edges()
		
		# 跳过空行和注释（以 # 或 // 开头的行）
		if line.is_empty() or line.begins_with("#") or line.begins_with("//"):
			continue
			
		# 按照等号切割，确保只切一次，避免文本里自带等号导致解析失败
		var split = line.split("=", true, 1)
		if split.size() == 2:
			var key = split[0].strip_edges()
			# 把读出来的字面量 \n 替换成真正的换行符
			var val = split[1].strip_edges().replace("\\n", "\n")
			# 存入字典（如果加载的是目标语言，会直接覆盖掉之前加载的中文兜底）
			translations[key] = val
			
	file.close()

# 供外部调用的翻译函数
func tr_text(key: String) -> String:
	# 如果在字典里找到了，就返回翻译；如果没找到，就直接返回 Key 本身，方便排错
	return translations.get(key, key)
