extends Control

@export var main_scene_scene : PackedScene

func _on_Play_pressed():
	get_tree().change_scene_to_packed(main_scene_scene)

func _on_Quit_pressed():
	get_tree().quit()
