extends Control

@onready var keyboard_focused = $VBoxContainer/StartButton

func _ready():
	focus()

# sets the curr keyboard_focused to focus
func focus():
	keyboard_focused.grab_focus()

# start button pressed
func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/space.tscn")
	
# start button hovering
func _on_start_button_mouse_entered():
	$VBoxContainer/StartButton.grab_focus()
	
# start button focused 
func _on_start_button_focus_entered():
	keyboard_focused = $VBoxContainer/StartButton
	
	
# options button pressed
func _on_options_button_pressed():
	pass

# options button hovering
func _on_options_button_mouse_entered():
	$VBoxContainer/OptionsButton.grab_focus()

# options button focused
func _on_options_button_focus_entered():
	keyboard_focused = $VBoxContainer/OptionsButton


# quit button pressed
func _on_quit_button_pressed():
	get_tree().quit()

# quit button hovering
func _on_quit_button_mouse_entered():
	$VBoxContainer/QuitButton.grab_focus()

# quit button focused
func _on_quit_button_focus_entered():
	keyboard_focused = $VBoxContainer/QuitButton
