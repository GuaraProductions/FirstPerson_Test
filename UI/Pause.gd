extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
	
func _exit_menu():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false
	self.queue_free()
		
func _on_Continue_pressed():
	_exit_menu()
	
func _on_Back_to_Menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://UI/MainMenu.tscn")
	self.queue_free()
	
func _on_Quit_pressed():
	get_tree().quit()
