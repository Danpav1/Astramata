extends Control

var focused_button
var main_instance
var blur_start = 2.5
var blur_current = 2.5
var accumulated_time = 0.0
var start_blur_animation = false  # Flag to control when the blur animation should run

func _ready():
	add_to_group("main_menu")
	main_instance = get_tree().current_scene
	focused_button = $VBoxContainer/StartButton
	focus()



func show_main_menu():
	show()

# Start the blur animation when the start button is pressed
func _on_start_button_pressed():
	main_instance.spawn_player()
	hide()
	#start_blur_animation = true

# sets the curr focused_button to focus
func focus():
	if is_instance_valid(focused_button):
		focused_button.grab_focus()
	
# start button hovering
func _on_start_button_mouse_entered():
	$VBoxContainer/StartButton.grab_focus()
	
# start button focused 
func _on_start_button_focus_entered():
	focused_button = $VBoxContainer/StartButton
	
	
# options button pressed
func _on_options_button_pressed():
	hide()
	get_tree().call_group("options_menu", "show_options")

# options button hovering
func _on_options_button_mouse_entered():
	$VBoxContainer/OptionsButton.grab_focus()

# options button focused
func _on_options_button_focus_entered():
	focused_button = $VBoxContainer/OptionsButton


# quit button pressed
func _on_quit_button_pressed():
	get_tree().quit()

# quit button hovering
func _on_quit_button_mouse_entered():
	$VBoxContainer/QuitButton.grab_focus()

# quit button focused
func _on_quit_button_focus_entered():
	focused_button = $VBoxContainer/QuitButton
