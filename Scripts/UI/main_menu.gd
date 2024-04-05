extends Control

# Define signals to communicate with the game controller
signal start_game
signal show_options
signal quit_game

var focused_button

func _ready():
	focused_button = $VBoxContainer/StartButton
	focus()

func focus():
	if is_instance_valid(focused_button):
		focused_button.grab_focus()

# Start button actions
func _on_start_button_pressed():
	emit_signal("start_game")

func _on_start_button_mouse_entered():
	$VBoxContainer/StartButton.grab_focus()

func _on_start_button_focus_entered():
	focused_button = $VBoxContainer/StartButton

# Options button actions
func _on_options_button_pressed():
	emit_signal("show_options")

func _on_options_button_mouse_entered():
	$VBoxContainer/OptionsButton.grab_focus()

func _on_options_button_focus_entered():
	focused_button = $VBoxContainer/OptionsButton

# Quit button actions
func _on_quit_button_pressed():
	emit_signal("quit_game")

func _on_quit_button_mouse_entered():
	$VBoxContainer/QuitButton.grab_focus()

func _on_quit_button_focus_entered():
	focused_button = $VBoxContainer/QuitButton
