extends Control

# Define signals to communicate with the game controller
signal start_game
signal show_options
signal quit_game
signal button_focused

@onready var focused_button = $VBoxContainer/StartButton

func focus():
	emit_signal("button_focused")
	if is_instance_valid(focused_button):
		focused_button.grab_focus()

# Start button actions
func _on_start_button_pressed():
	emit_signal("start_game")

func _on_start_button_mouse_entered():
	focused_button = $VBoxContainer/StartButton
	focus()

func _on_start_button_focus_entered():
	focused_button = $VBoxContainer/StartButton
	focus()

# Options button actions
func _on_options_button_pressed():
	emit_signal("show_options")

func _on_options_button_mouse_entered():
	focused_button = $VBoxContainer/OptionsButton
	focus()

func _on_options_button_focus_entered():
	focused_button = $VBoxContainer/OptionsButton
	focus()

# Quit button actions
func _on_quit_button_pressed():
	emit_signal("quit_game")

func _on_quit_button_mouse_entered():
	focused_button = $VBoxContainer/QuitButton
	focus()

func _on_quit_button_focus_entered():
	focused_button = $VBoxContainer/QuitButton
	focus()
