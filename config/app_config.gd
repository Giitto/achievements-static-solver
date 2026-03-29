class_name AppConfig
extends Resource

@export var steam_api_key:String
@export var steam_user_id:String

func _init(p_steam_key: String = "", p_user_id: String = "") -> void:
	steam_api_key = p_steam_key
	steam_user_id = p_user_id
