extends Control

var focused_button
var paused = false

func _ready():
	focused_button = $VBoxContainer/RespawnButton
	focus()

# sets the curr keyboard_focused to focus
func focus():
	if is_instance_valid(focused_button):
		focused_button.grab_focus()

# resume button
func _on_respawn_button_pressed():
	get_tree().call_group("game_control", "spawn_player")
	hide()

# resume button hovering
func _on_respawn_button_mouse_entered():
	$VBoxContainer/RespawnButton.grab_focus()

# resume button focused
func _on_respawn_button_focus_entered():
	focused_button = $VBoxContainer/RespawnButton



# main menu button
func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
	
# main menu button hovering
func _on_main_menu_button_mouse_entered():
	$VBoxContainer/MainMenuButton.grab_focus()

# main menu button focused
func _on_main_menu_button_focus_entered():
	focused_button = $VBoxContainer/MainMenuButton



# quit button hovering
func _on_quit_button_pressed():
	get_tree().quit()

# quit button hovering
func _on_quit_button_mouse_entered():
	$VBoxContainer/QuitButton.grab_focus()

# quit button focused
func _on_quit_button_focus_entered():
	focused_button = $VBoxContainer/QuitButton
