extends Control

@onready var focused_button = $VBoxContainer/StartButton
var main_instance
var blur_start = 2.5
var blur_current = 2.5
var accumulated_time = 0.0
var start_blur_animation = false  # Flag to control when the blur animation should run


func _ready():
	main_instance = get_tree().current_scene
	focus()

func _process(delta):
	if start_blur_animation:  # Check if the blur animation should run
		accumulated_time += delta

		if blur_current != 0 and accumulated_time >= 0.05:
			$Astromata.hide()
			$VBoxContainer.hide()
			accumulated_time = 0  # Reset the timer
			blur_current -= 0.1  # Decrease blur amount
			var material = $Blur.material as ShaderMaterial
			material.set_shader_parameter("blur_amount", blur_current)
		
		if blur_current <= 0:  # Check if the blur animation is done
			start_blur_animation = false  # Stop the blur animation
			hide()

# Start the blur animation when the start button is pressed
func _on_start_button_pressed():
	main_instance.spawn_player()
	start_blur_animation = true

# sets the curr focused_button to focus
func focus():
	focused_button.grab_focus()
	
# start button hovering
func _on_start_button_mouse_entered():
	$VBoxContainer/StartButton.grab_focus()
	
# start button focused 
func _on_start_button_focus_entered():
	focused_button = $VBoxContainer/StartButton
	
	
# options button pressed
func _on_options_button_pressed():
	pass

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
