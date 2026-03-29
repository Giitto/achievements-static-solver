class_name SteamImportWindow extends Window

signal call_import_api(gameid:String)
@onready var game_id_input: LineEdit = %GameIdInput

func _on_close_pressed() -> void:
	self.hide()

func _on_import_pressed() -> void:
	call_import_api.emit(game_id_input.text)

func parse_api_response(json:Variant) -> Array[AchievementDict]:
	var parsed_achievements: Array[AchievementDict] = []
	for achievement: Dictionary in json.game.availableGameStats.achievements:
		parsed_achievements.append(AchievementDict.new(
		{"path_to_icon" : "",
		"title" : achievement.get("displayName") if achievement.get("displayName") else "",
		"description" : achievement.get("description") if achievement.get("description") else "",
		"guide_text" : "",
		"is_achievement_done" : false,
		"is_folded" : false}))
	return parsed_achievements

func update_error_text(error:String) -> void:
	
	pass
