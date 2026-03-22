extends VBoxContainer
class_name RootElement

@onready var main: VBoxContainer = $"."
@onready var menu_button: MenuButton = $VBoxContainer/MenuButton
@onready var achievement_box: VBoxContainer = $ScrollContainer/AchievementBox

@onready var load_file_dialog: FileDialog = $LoadFileDialog
@onready var save_file_dialog: FileDialog = $SaveFileDialog

var is_edit_on :bool = false

var troph_list:Array[Achievement] = [];

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
	# Make FileDialog popout of the game engine
	load_file_dialog.set_use_native_dialog(true)
	load_file_dialog.set_force_native(true)
	save_file_dialog.set_use_native_dialog(true)
	save_file_dialog.set_force_native(true)

## Create a new instance of Achievement and put it in the VBoxContainer AchievementBox
func _on_add_achievement_button_pressed() -> void:
	add_achievement()

func add_achievement(data : Dictionary = {}) -> void:
	var ui_scene = preload("res://Achievement/achievement_desc.tscn")
	var ui_instance : Achievement = ui_scene.instantiate()
	achievement_box.add_child(ui_instance)
	troph_list.append(ui_instance)
	if !data.is_empty():
		ui_instance.from_dict(AchievementDict.new(data))
		ui_instance.toggle_edit(is_edit_on)

func _on_option_item_selected(index: int) -> void:
	if index == 0:
		save_achievement_state()
	elif index == 1:
		load_achievement_state()

func save_achievement_state() -> void:
	save_file_dialog.popup_file_dialog()

func load_achievement_state() -> void:
	load_file_dialog.popup_file_dialog()

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
