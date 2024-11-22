extends MarginContainer

signal go_to_main_menu()

func _ready() -> void:
	visible = false

func _unhandled_key_input(event: InputEvent) -> void:
			
	if event.is_action_pressed("ui_home"):
		get_tree().paused = true
		visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func _exit_menu():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false
	visible = false
		
func _on_Continue_pressed():
	_exit_menu()
	
func _on_Back_to_Menu_pressed():
	get_tree().paused = false
	go_to_main_menu.emit()
	
func _on_Quit_pressed():
	get_tree().quit()
