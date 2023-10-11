extends Node3D

@onready var world_environment : WorldEnvironment = $WorldEnvironment

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event):
	
	if event.is_action_pressed("ui_accept"):
		print("aqui")
		world_environment.environment.ssr_enabled = true
		ProjectSettings.set_setting("rendering/anti_aliasing/quality/msaa_3d",2)
