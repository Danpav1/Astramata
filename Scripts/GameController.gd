extends Node

# Define properties for the game state
var is_game_paused = false
var is_main_menu_visible = false
var is_pause_menu_visible = false
var is_death_menu_visible = false
var is_options_menu_visible = false

# References to scenes (preloaded)
var main_menu_scene = preload("res://Scenes/UI/main_menu.tscn")
var pause_menu_scene = preload("res://Scenes/UI/pause_menu.tscn")
var options_menu_scene = preload("res://Scenes/UI/options_menu.tscn")
var death_menu_scene = preload("res://Scenes/UI/death_menu.tscn")
var player_scene = preload("res://Scenes/Gameplay/Entities/Player/player.tscn")

# UI Layers
var ui_layer_main_menu
var ui_layer_pause_menu
var ui_layer_death_menu
var ui_layer_options_menu

# Instances of menus
var main_menu
var pause_menu
var options_menu
var death_menu

# Other instances
var player_instance

# Other vars
var back_destination

@export var focusStream: AudioStream
@export var selectStream: AudioStream
@export var backStream: AudioStream

func _ready():
	init_menus()
	show_main_menu()
	
func _process(delta):
	if not is_main_menu_visible and not is_death_menu_visible and not is_options_menu_visible:
		if Input.is_action_just_pressed("ui_escape"):
			if is_pause_menu_visible == true:
				AudioController.play_sfx(backStream)
				hide_pause_menu()
			else:
				AudioController.play_sfx(selectStream)
				show_pause_menu()
	if is_options_menu_visible:
		if Input.is_action_just_pressed("ui_escape"):
			AudioController.play_sfx(selectStream)
			_on_go_back()

func init_menus():
	main_menu = main_menu_scene.instantiate()
	ui_layer_main_menu = get_node("/root/main/CanvasLayerMainMenu")
	ui_layer_main_menu.add_child(main_menu)
	main_menu.hide()
	# Connections for main menu signals
	main_menu.connect("start_game", _on_start_game)
	main_menu.connect("show_options", _on_show_options_from_main)
	main_menu.connect("quit_game", _on_quit_game)
	main_menu.connect("button_focused", _on_button_focused)

	pause_menu = pause_menu_scene.instantiate()
	ui_layer_pause_menu = get_node("/root/main/CanvasLayerPauseMenu")
	ui_layer_pause_menu.add_child(pause_menu)
	pause_menu.hide()
	# Connections for pause menu signals
	pause_menu.connect("resume_game", _on_resume_game)
	pause_menu.connect("show_options", _on_show_options_from_pause)
	pause_menu.connect("go_main", _on_go_new_main)
	pause_menu.connect("quit_game", _on_quit_game)
	pause_menu.connect("button_focused", _on_button_focused)

	options_menu = options_menu_scene.instantiate()
	ui_layer_options_menu = get_node("/root/main/CanvasLayerOptionsMenu")
	ui_layer_options_menu.add_child(options_menu)
	options_menu.hide()
	# Connections for options menu signals
	options_menu.connect("go_back", _on_go_back)
	options_menu.connect("apply_changes", _on_apply_changes)
	options_menu.connect("slider_moved", _on_slider_moved)
	options_menu.connect("button_focused", _on_button_focused)
	
	death_menu = death_menu_scene.instantiate()
	ui_layer_death_menu = get_node("/root/main/CanvasLayerDeathMenu")
	ui_layer_death_menu.add_child(death_menu)
	death_menu.hide()
	# Connections for death menu signals
	death_menu.connect("respawn_player", _on_respawn_player)
	death_menu.connect("go_main", _on_go_new_main)
	death_menu.connect("quit_game", _on_quit_game)
	death_menu.connect("button_focused", _on_button_focused)

func _on_button_focused():
	AudioController.play_sfx(focusStream)

func _on_go_new_main():
	AudioController.play_sfx(selectStream)
	hide_death_menu() # if its shown
	hide_pause_menu() # if its shown
	remove_player()
	show_main_menu()
	is_death_menu_visible = false
	is_pause_menu_visible = false

func _on_slider_moved():
	AudioController.play_sfx(selectStream)

func _on_apply_changes(music_volume_db, sfx_volume_db):
	AudioController.play_sfx(selectStream)
	AudioController.set_music_volume(music_volume_db)
	AudioController.set_sfx_volume(sfx_volume_db)

func _on_respawn_player():
	AudioController.play_sfx(selectStream)
	hide_death_menu()
	remove_player()
	spawn_player()
	is_death_menu_visible = false

func _on_go_back():
	AudioController.play_sfx(backStream)
	hide_options()
	if back_destination == "main_menu":
		show_main_menu()
		back_destination = ""
	if back_destination == "pause_menu":
		show_pause_menu()
		back_destination = ""		
	
func _on_quit_game():
	AudioController.play_sfx(selectStream)
	get_tree().quit()

func _open_death_menu():
	show_death_menu()
	death_menu.focus()
	is_death_menu_visible = true

func _on_go_main():
	AudioController.play_sfx(selectStream)
	hide_death_menu() # if its shown
	hide_pause_menu() # if its shown
	remove_player()
	show_main_menu()
	is_death_menu_visible = false
	is_pause_menu_visible = false

func _on_resume_game():
	AudioController.play_sfx(selectStream)
	hide_pause_menu()

func _on_start_game():
	AudioController.play_sfx(selectStream)
	hide_main_menu()
	spawn_player()

func _on_show_options_from_main():
	AudioController.play_sfx(selectStream)
	back_destination = "main_menu"
	hide_main_menu()
	options_menu.show()
	options_menu.focus()
	is_options_menu_visible = true
	
func _on_show_options_from_pause():
	AudioController.play_sfx(selectStream)
	back_destination = "pause_menu"
	hide_pause_menu()
	set_pause_state(true)
	options_menu.show()
	options_menu.focus()
	is_options_menu_visible = true
	
func show_main_menu():
	main_menu.show()
	is_main_menu_visible = true
	main_menu.focus()

func hide_main_menu():
	main_menu.hide()
	is_main_menu_visible = false

func show_pause_menu():
	pause_menu.show()
	is_game_paused = true
	is_pause_menu_visible = true
	set_pause_state(true)
	pause_menu.focus()
	
func hide_pause_menu():
	pause_menu.hide()
	is_game_paused = false
	is_pause_menu_visible = false
	set_pause_state(false)
	
func hide_options():
	options_menu.hide()
	is_options_menu_visible = false
	
func show_death_menu():
	death_menu.show()
	death_menu.focus()
	
func hide_death_menu():
	death_menu.hide()

func spawn_player():
	player_instance = player_scene.instantiate()
	player_instance.connect("player_died", _open_death_menu)
	add_child(player_instance)
	
func remove_player():
	player_instance.queue_free()

func toggle_pause_menu():
	if is_main_menu_visible:
		return  # Don't toggle pause menu if main menu is visible

	is_pause_menu_visible = !is_pause_menu_visible
	pause_menu.visible = is_pause_menu_visible
	set_pause_state(is_pause_menu_visible)

func set_pause_state(pause):
	is_game_paused = pause
	get_tree().paused = pause

