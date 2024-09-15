extends Node3D

@onready var world_environment : WorldEnvironment = $WorldEnvironment

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
