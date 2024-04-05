extends Control

signal respawn_player
signal go_main
signal quit_game
signal button_focused

@onready var focused_button = $VBoxContainer/RespawnButton

# sets the curr keyboard_focused to focus
func focus():
	emit_signal("button_focused")
	if is_instance_valid(focused_button):
		focused_button.grab_focus()

# resume button
func _on_respawn_button_pressed():
	emit_signal("respawn_player")

# resume button hovering
func _on_respawn_button_mouse_entered():
	focused_button = $VBoxContainer/RespawnButton
	focus()

# resume button focused
func _on_respawn_button_focus_entered():
	focused_button = $VBoxContainer/RespawnButton
	focus()

# main menu button
func _on_main_menu_button_pressed():
	emit_signal("go_main")
	
# main menu button hovering
func _on_main_menu_button_mouse_entered():
	focused_button = $VBoxContainer/MainMenuButton
	focus()

# main menu button focused
func _on_main_menu_button_focus_entered():
	focused_button = $VBoxContainer/MainMenuButton
	focus()

# quit button hovering
func _on_quit_button_pressed():
	emit_signal("quit_game")

# quit button hovering
func _on_quit_button_mouse_entered():
	focused_button = $VBoxContainer/QuitButton
	focus()

# quit button focused
func _on_quit_button_focus_entered():
	focused_button = $VBoxContainer/QuitButton
	focus()
