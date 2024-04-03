extends Control

@onready var focused_button = $VBoxContainer/RespawnButton
var paused = false

func _ready():
	focus()

# sets the curr keyboard_focused to focus
func focus():
	if is_instance_valid(focused_button):
		focused_button.grab_focus()

# resume button
func _on_respawn_button_pressed():
	#self.spawn_player()
	get_tree()

# resume button hovering
func _on_respawn_button_mouse_entered():
	$VBoxContainer/RespawnButton.grab_focus()

# resume button focused
func _on_respawn_button_focus_entered():
	focused_button = $VBoxContainer/RespawnButton



# options button
func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
	
# options button hovering
func _on_main_menu_button_mouse_entered():
	$VBoxContainer/MainMenuButton.grab_focus()

# options button focused
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