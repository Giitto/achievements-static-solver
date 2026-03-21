extends VBoxContainer
class_name Achievement

@onready var icon: TextureRect = $AchievementsDesc/Icon
@onready var icon_click: Button = $AchievementsDesc/Icon/IconClick
@onready var image_selection: FileDialog = $AchievementsDesc/ImageSelection

@onready var title: LineEdit = $AchievementsDesc/Title/Title
@onready var desciption_text_edit: TextEdit = $AchievementsDesc/Title/DesciptionTextEdit
@onready var guide_detail: RichTextLabel = $GuideDetail
@onready var delete_achievement_button: Button = $AchievementsDesc/DeleteAchievementButton
@onready var guide_edit: TextEdit = $GuideEdit
var bbcode_string: String = ""


func _ready() -> void:
	delete_achievement_button.visible = false
	icon_click.size = icon.size
	bbcode_string = guide_detail.text
	guide_edit.visible = false
	guide_edit.text = guide_detail.text
	
	## Setting up default state of FileDialog
	image_selection.filters = PackedStringArray([
	"*.bmp,*.dds,*.ktx,*.exr,*.hdr,*.jpg,*.jpeg,*.png,*.tga,*.svg,*.webp ; Image Files"
	])
	image_selection.set_file_mode(FileDialog.FILE_MODE_OPEN_FILE)
	image_selection.set_access(FileDialog.ACCESS_FILESYSTEM)
	image_selection.set_use_native_dialog(true) ## Made native
	image_selection.set_force_native(true) ## Force native

func toggle_edit(act : bool) -> void:
	toggle_icon_onclick_event(act)
	toggle_guide_text(act)
	title.editable = act
	desciption_text_edit.editable = act
	delete_achievement_button.visible = act

func toggle_guide_text(act : bool) -> void:
	if act :
		guide_edit.text = bbcode_string
	else :
		bbcode_string = guide_edit.text
		guide_detail.clear()
		guide_detail.append_text(guide_edit.text)
	guide_detail.visible = !act
	guide_edit.visible = act
	guide_edit.editable = act
	


func toggle_icon_onclick_event(act : bool) -> void:
	if act:
		icon_click.pressed.connect(_icon_on_click_event)
	else:
		icon_click.pressed.disconnect(_icon_on_click_event)

func _icon_on_click_event() -> void: 
	image_selection.popup_centered_ratio()

func _on_image_selection_file_selected(path: String) -> void:
	icon.texture = ImageTexture.create_from_image(Image.load_from_file(path))


func _on_delete_achievement_button_pressed() -> void:
	print("Oui")
	var root = self.get_parent()
	while root is not RootElement || root == null:
		root = root.get_parent()
		
	if root is RootElement:
		root.troph_list.erase(self)
		root.remove_child(self)
		self.call_deferred("queue_free")
