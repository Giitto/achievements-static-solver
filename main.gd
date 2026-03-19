extends VBoxContainer

@onready var main: VBoxContainer = $"."
@onready var menu_button: MenuButton = $VBoxContainer/MenuButton

var troph_list:Array[Node] = [];

func _ready() -> void:
	menu_button.get_popup().id_pressed.connect(_on_option_item_selected)
	for ach in troph_list:
		add_child(ach.instantiate())


func _on_add_achivement_button_pressed() -> void:
	var ui_scene = preload("res://Achievement/achievement_desc.tscn")
	var ui_instance = ui_scene.instantiate()
	add_child(ui_instance)
	troph_list.append(ui_instance)
	print(troph_list)

func _on_option_item_selected(index: int) -> void:
	if index == 0:
		print("Save") 
	elif index == 1:
		print("Load")
