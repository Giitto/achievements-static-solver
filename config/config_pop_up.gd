extends Window 
class_name ConfigWindow

@onready var steam_key_value: LineEdit = %SteamKeyValue
@onready var steam_user_id_value: LineEdit = %SteamUserIdValue
var app_config_ressource: AppConfig = preload("res://config/app_config.tres")
var CONFIG_PATH: String = "user://ass_app_config.tres"

func _ready() -> void:
	self.close_requested.connect(_on_save_config_button_pressed)
	print(OS.get_user_data_dir())
	if ResourceLoader.exists(CONFIG_PATH) :
		load_config()
		steam_key_value.text = app_config_ressource.steam_api_key
		steam_user_id_value.text = app_config_ressource.steam_user_id

func _on_save_config_button_pressed() -> void:
	app_config_ressource.steam_api_key = steam_key_value.text
	app_config_ressource.steam_user_id = steam_user_id_value.text
	ResourceSaver.save(app_config_ressource,CONFIG_PATH)

func _on_close_button_pressed() -> void:
	print(app_config_ressource.steam_api_key)
	print(app_config_ressource.steam_user_id)
	self.hide()

func load_config(path: String = CONFIG_PATH):
	if ResourceLoader.exists(CONFIG_PATH) :
		app_config_ressource = ResourceLoader.load(CONFIG_PATH,"",ResourceLoader.CACHE_MODE_IGNORE)
	else:
		steam_key_value.text = ""
		steam_user_id_value.text = ""
