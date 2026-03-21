extends VBoxContainer

@onready var main: VBoxContainer = $"."
@onready var menu_button: MenuButton = $VBoxContainer/MenuButton
@onready var achievment_box: VBoxContainer = $ScrollContainer/AchievmentBox

var is_edit_on :bool = false

var troph_list:Array[Achievement] = [];

func _ready() -> void:
	menu_button.get_popup().id_pressed.connect(_on_option_item_selected)
	for ach in troph_list:
		ach.toggle_edit(is_edit_on)
		add_child(ach.instantiate())


func _on_add_achivement_button_pressed() -> void:
	var ui_scene = preload("res://Achievement/achievement_desc.tscn")
	var ui_instance : Achievement = ui_scene.instantiate()
	#ui_instance.toggle_edit(is_edit_on)
	achievment_box.add_child(ui_instance)
	troph_list.append(ui_instance)

func _on_option_item_selected(index: int) -> void:
	if index == 0:
		print("Save") 
	elif index == 1:
		print("Load")


func _on_edit_mode_toggled(toggled_on: bool) -> void:
	is_edit_on = toggled_on
	for troph : Achievement in troph_list:
		troph.toggle_edit(toggled_on)
