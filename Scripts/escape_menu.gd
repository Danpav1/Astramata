extends Control

var main_instance
@onready var focused_button = $VBoxContainer/ResumeButton
var paused = false

func _ready():
	main_instance = get_tree().current_scene
	focus()

func _process(delta):
	if Input.is_action_just_pressed("ui_escape") and paused == true:
		paused = false
		main_instance.get_tree().paused = false
		hide()
	elif Input.is_action_just_pressed("ui_escape") and paused == false:
		paused = true
		main_instance.get_tree().paused = true
		show()
		focused_button.grab_focus()

# sets the curr keyboard_focused to focus
func focus():
	focused_button.grab_focus()

# resume button
func _on_resume_button_pressed():
	paused = false
	main_instance.get_tree().paused = false
	self.hide()

# resume button hovering
func _on_resume_button_mouse_entered():
	$VBoxContainer/ResumeButton.grab_focus()

# resume button focused
func _on_resume_button_focus_entered():
	focused_button = $VBoxContainer/ResumeButton



# options button
func _on_options_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	
# options button hovering
func _on_options_button_mouse_entered():
	$VBoxContainer/OptionsButton.grab_focus()

# options button focused
func _on_options_button_focus_entered():
	focused_button = $VBoxContainer/OptionsButton



# quit button hovering
func _on_quit_button_pressed():
	get_tree().quit()

# quit button hovering
func _on_quit_button_mouse_entered():
	$VBoxContainer/QuitButton.grab_focus()

# quit button focused
func _on_quit_button_focus_entered():
	focused_button = $VBoxContainer/QuitButton
