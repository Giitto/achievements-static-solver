extends VBoxContainer
class_name Achievement

var default_img = load("res://assets/default_icon.svg")
@onready var icon: TextureRect = $AchievementsDesc/LeftSide/Icon
var img_path: String = ""
@onready var icon_click: Button = $AchievementsDesc/LeftSide/Icon/IconClick
@onready var image_selection: FileDialog = $AchievementsDesc/ImageSelection

@onready var done_check_box: CheckBox = $AchievementsDesc/Title/ManageDeleteButton/done
@onready var title: LineEdit = $AchievementsDesc/Title/ManageDeleteButton/Title
@onready var description_text_edit: TextEdit = $AchievementsDesc/Title/DescriptionTextEdit
@onready var delete_achievement_button: Button = $AchievementsDesc/Title/ManageDeleteButton/DeleteAchievementButton

@onready var guide_detail: RichTextLabel = $GuideDetail
@onready var guide_edit: TextEdit = $GuideEdit
var guide_bbcode_string: String = "" # Used to stock the raw BBCode so we can retrieve it

@export var MIN_SIZE_DEFAULT : Vector2 = Vector2(248,80)
@export var MIN_SIZE_FOLDED : Vector2 = Vector2(248,50)

var is_edit_on: bool = false
var is_achievement_done: bool = false
var is_folded: bool = false

func _ready() -> void:
	$".".custom_minimum_size = MIN_SIZE_DEFAULT
	
	## Make sure that on creation the edit mode is false, use toggle_edit(bool) to enable edit mode
	delete_achievement_button.visible = false
	guide_edit.visible = false
	guide_edit.editable = false
	guide_bbcode_string = guide_detail.text
	guide_edit.text = guide_detail.text
	hide_guide_if_empty()
	
	## Setting up default state of FileDialog
	# Filter on compatible image type of godot "Image" class
	image_selection.filters = PackedStringArray([
	"*.bmp,*.dds,*.ktx,*.exr,*.hdr,*.jpg,*.jpeg,*.png,*.tga,*.svg,*.webp ; Image Files"
	])
	image_selection.set_file_mode(FileDialog.FILE_MODE_OPEN_FILE)
	image_selection.set_access(FileDialog.ACCESS_FILESYSTEM)
	# Make FileDialog popout of the game engine
	image_selection.set_use_native_dialog(true)
	image_selection.set_force_native(true)

func toggle_edit(is_edit : bool) -> void:
	is_edit_on = is_edit
	delete_achievement_button.visible = is_edit
	title.editable = is_edit
	toggle_icon_onclick_event(is_edit)
	if is_folded:
		return
	untoggle_edit_logic(is_edit_on)

func untoggle_edit_logic(is_edit : bool) -> void:
	toggle_guide_text(is_edit)
	description_text_edit.editable = is_edit

# Swap between GuideDetail and GuideEdit visibility
func toggle_guide_text(is_edit : bool) -> void:
	if is_edit :
		guide_edit.text = guide_bbcode_string
	else :
		guide_bbcode_string = guide_edit.text
		guide_detail.clear()
		guide_detail.append_text(guide_edit.text)
	
	guide_detail.visible = !is_edit
	guide_edit.visible = is_edit
	guide_edit.editable = is_edit
	hide_guide_if_empty()

# Connect and disconnect the Icon button depending on edit mode
func toggle_icon_onclick_event(is_edit : bool) -> void:
	if is_edit && !icon_click.pressed.is_connected(_icon_on_click_event):
		icon_click.pressed.connect(_icon_on_click_event)
	elif !is_edit && icon_click.pressed.is_connected(_icon_on_click_event):
		icon_click.pressed.disconnect(_icon_on_click_event)

# Open FileDialog to load an image for this achievement
func _icon_on_click_event() -> void: 
	image_selection.popup_centered_ratio()

# Called by imageselection FileDialog on file selected
func _on_image_selection_file_selected(path: String) -> void:
	if path.is_empty():
		put_default_icon()
		return
	img_path = path
	var img: Image = Image.load_from_file(path)
	if img == null:
		put_default_icon()
		return
	img.resize(32,32)
	icon.texture = ImageTexture.create_from_image(img)

func put_default_icon() -> void:
	icon.texture = default_img

# Delete the Achievement from the main list before freeing it from memory
func _on_delete_achievement_button_pressed() -> void:
	var root = self.get_parent()
	# Not sure of this one but i just want to make it functional for the moment
	while root is not RootElement || root == null:
		root = root.get_parent()
		
	if root is RootElement:
		root.troph_list.erase(self)
		root.remove_child(self)
		self.call_deferred("queue_free") # better safe than sorry

func _on_fold_button_pressed() -> void:
	description_text_edit.visible = is_folded
	guide_detail.visible = is_folded
	guide_edit.visible = is_folded
	is_folded = !is_folded
	if is_folded : 
		$".".custom_minimum_size = MIN_SIZE_FOLDED 
	else :
		$".".custom_minimum_size = MIN_SIZE_DEFAULT
		untoggle_edit_logic(is_edit_on)

func hide_guide_if_empty() -> void:
	if guide_detail.text.is_empty():
		guide_detail.visible = false

func _on_done_toggled(toggled_on: bool) -> void:
	is_achievement_done = toggled_on

func to_dict() -> AchievementDict:
	return AchievementDict.new({
		"path_to_icon" : img_path,
		"title" : title.text,
		"description" : description_text_edit.text,
		"guide_text" : guide_bbcode_string,
		"is_achievement_done" : is_achievement_done,
		"is_folded" : is_folded
	})

func from_dict(achievement_dict : AchievementDict) -> void:
	_on_image_selection_file_selected(achievement_dict.achievement_dict.get("path_to_icon"))
	title.text = achievement_dict.achievement_dict.get("title")
	description_text_edit.text = achievement_dict.achievement_dict.get("description")
	guide_bbcode_string = achievement_dict.achievement_dict.get("guide_text")
	guide_detail.text = achievement_dict.achievement_dict.get("guide_text")
	guide_edit.text = achievement_dict.achievement_dict.get("guide_text")
	is_achievement_done = achievement_dict.achievement_dict.get("is_achievement_done")
	done_check_box.button_pressed = is_achievement_done
	is_folded = !achievement_dict.achievement_dict.get("is_folded")
	_on_fold_button_pressed()

func _to_string() -> String:
	return to_dict().to_string()
