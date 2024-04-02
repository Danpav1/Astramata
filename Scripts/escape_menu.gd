extends Control

@onready var space = preload("res://Scenes/space.tscn")
var keyboard_focused = null

# resume button
func _on_resume_button_pressed():
	var space_instance = get_tree().current_scene
	if space_instance and space_instance.has_method("escapeMenu"):
		space_instance.escapeMenu()

# resume button hovering
func _on_resume_button_mouse_entered():
	$VBoxContainer/ResumeButton.grab_focus()

# resume button focused
func _on_resume_button_focus_entered():
	keyboard_focused = $VBoxContainer/ResumeButton



# options button
func _on_options_button_pressed():
	pass 
	
# options button hovering
func _on_options_button_mouse_entered():
	$VBoxContainer/OptionsButton.grab_focus()

# options button focused
func _on_options_button_focus_entered():
	keyboard_focused = $VBoxContainer/OptionsButton



# quit button hovering
func _on_quit_button_pressed():
	get_tree().quit()

# quit button hovering
func _on_quit_button_mouse_entered():
	$VBoxContainer/QuitButton.grab_focus()

# quit button focused
func _on_quit_button_focus_entered():
	keyboard_focused = $VBoxContainer/QuitButton
