extends Control

@onready var space = preload("res://Scenes/space.tscn")

func _ready():
	$VBoxContainer/ResumeButton.grab_focus()

# start button
func _on_resume_button_pressed():
	var space_instance = get_tree().current_scene
	if space_instance and space_instance.has_method("escapeMenu"):
		space_instance.escapeMenu()

# options button
func _on_options_button_pressed():
	pass 

# quit button
func _on_quit_button_pressed():
	get_tree().quit()
