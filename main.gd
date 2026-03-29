extends VBoxContainer
class_name RootElement

@onready var ACHIEVEMENT_SCENE = preload("res://Achievement/achievement_desc.tscn")

@onready var main: VBoxContainer = $"."
@onready var menu_button: MenuButton = $%Option
@onready var achievement_box: VBoxContainer = $%AchievementBox

@onready var load_file_dialog: FileDialog = $%LoadFileDialog
@onready var save_file_dialog: FileDialog = $%SaveFileDialog
@onready var confirmation_dialog: ConfirmationDialog = $%ConfirmationDialog
@onready var config_pop_up: ConfigWindow = %ConfigWindow
@onready var steam_import_window: SteamImportWindow = %SteamImportWindow

@onready var steam_game_achivement_api_call: HTTPRequest = %SteamGameAchivementAPICall
var urlSchemaForGame:="https://api.steampowered.com/ISteamUserStats/GetSchemaForGame/v2/?"

var is_edit_on :bool = false

var troph_list:Array[Achievement] = [];

func call_steam_api(app_id:String):
	var key := config_pop_up.steam_key_value.text
	var final_url := urlSchemaForGame + "appid=" + app_id + "&key=" + key
	steam_game_achivement_api_call.request(final_url)
	return

func _ready() -> void:
	menu_button.get_popup().id_pressed.connect(_on_option_item_selected)
	for ach in troph_list:
		ach.toggle_edit(is_edit_on)
		add_child(ach.instantiate())
		
	## Setting up default state of FileDialog
	# Filter file type
	load_file_dialog.filters = PackedStringArray([
	"*.ass ; Achievements file"
	])
	save_file_dialog.filters = PackedStringArray([
	"*.ass ; Achievements file"
	])
	load_file_dialog.set_file_mode(FileDialog.FILE_MODE_OPEN_FILE)
	load_file_dialog.set_access(FileDialog.ACCESS_FILESYSTEM)
	save_file_dialog.set_file_mode(FileDialog.FILE_MODE_SAVE_FILE)
	save_file_dialog.set_access(FileDialog.ACCESS_FILESYSTEM)


## Create a new instance of Achievement and put it in the VBoxContainer AchievementBox
func _on_add_achievement_button_pressed() -> void:
	add_achievement()

func add_achievement(data : Dictionary = {}) -> void:
	var new_achievement = instanciate_new_achievement()
	if !data.is_empty():
		new_achievement.from_dict(AchievementDict.new(data))
	new_achievement.toggle_edit(is_edit_on)

func add_achievement_from_achievement_dict(data : AchievementDict) -> void:
	var new_achievement = instanciate_new_achievement()
	new_achievement.from_dict(data)
	new_achievement.toggle_edit(is_edit_on)

func instanciate_new_achievement() -> Achievement:
	var ui_instance : Achievement = ACHIEVEMENT_SCENE.instantiate()
	achievement_box.add_child(ui_instance)
	troph_list.append(ui_instance)
	return ui_instance

func _on_option_item_selected(index: int) -> void:
	if index == 0:
		save_achievement_state()
	elif index == 1:
		load_achievement_state()
	elif index == 2:
		open_config_popup()
	elif index == 3:
		open_steam_import()

func save_achievement_state() -> void:
	save_file_dialog.popup_file_dialog()

func load_achievement_state() -> void:
	load_file_dialog.popup_file_dialog()

func open_config_popup() -> void:
	config_pop_up.show()
	config_pop_up.popup_centered()

func open_steam_import() -> void:
	steam_import_window.show()
	steam_import_window.popup_centered()

func _on_edit_mode_toggled(toggled_on: bool) -> void:
	is_edit_on = toggled_on
	for troph : Achievement in troph_list:
		troph.toggle_edit(toggled_on)

func _on_save_file_dialog_file_selected(path: String) -> void:
	var file = FileAccess.open(path,FileAccess.WRITE)
	file.store_string(parse_troph_list_to_string().c_unescape())
	file.close()

func parse_troph_list_to_string() -> String:
	var file_content: String = "[\n"
	var first=true
	for troph in troph_list:
		if first:
			file_content += troph.to_dict().to_string()
			first = false
		else:
			file_content += ",\n" + troph.to_dict().to_string()
	file_content += "\n]"
	return file_content

func _on_load_file_dialog_file_selected(path: String) -> void:
	var file = FileAccess.get_file_as_string(path)
	var json: JSON = JSON.new()
	var error = json.parse(file)
	if error == OK && !json.data.is_empty():
		empty_troph_list()
		for data in json.data:
			add_achievement(data)
	

func empty_troph_list() -> void :
	for troph in troph_list:
		achievement_box.remove_child(troph)
		troph.call_deferred("queue_free")
	troph_list.clear()

func _on_quit_pressed() -> void:
	confirmation_dialog.popup_centered()

func _on_confirmation_dialog_confirmed() -> void:
	get_tree().quit()

func _on_steam_game_achivement_api_call_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		print(response_code)
		print(headers)
		return
	var json = JSON.parse_string(body.get_string_from_utf8())
	if !json || !json.get("game"):
		print("game id not found")
		return
	var parsed:Array[AchievementDict] = steam_import_window.parse_api_response(json)
	if !parsed || parsed.is_empty():
		return
	for data in parsed:
		add_achievement_from_achievement_dict(data)
	steam_import_window.hide()

func _on_steam_import_window_call_import_api(gameid: String) -> void:
	call_steam_api(gameid)
