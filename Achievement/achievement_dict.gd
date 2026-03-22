extends Node
class_name AchievementDict

var achievement_dict : Dictionary = {
		"path_to_icon" : "img_path",
		"title" : "title",
		"description" : "description_text_edit.text",
		"guide_text" : "guide_bbcode_string",
		"is_achievement_done" : "is_achievement_done",
		"is_folded" : "is_folded"
	}
	
func _init(ach_dict:Dictionary) -> void:
	achievement_dict = ach_dict

func _to_string() -> String:
	return JSON.stringify(achievement_dict,"\t")
