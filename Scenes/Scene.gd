extends Node3D

@onready var world_environment : WorldEnvironment = $WorldEnvironment

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_pause_go_to_main_menu() -> void:
	get_tree().change_scene_to_file("res://UI/MainMenu.tscn")
