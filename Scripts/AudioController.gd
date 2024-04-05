extends Node

# Volume levels for different categories
var music_volume_db: float
var sfx_volume_db: float

func _ready():
	load_settings()

func play_sfx(stream: AudioStream):
	var instance = AudioStreamPlayer2D.new()
	instance.stream = stream
	instance.finished.connect(remove_node.bind(instance))
	instance.volume_db = sfx_volume_db
	add_child(instance)
	instance.play()
	
func remove_node(instance: AudioStreamPlayer2D):
	instance.queue_free()

func get_music_volume_db() -> float:
	return music_volume_db
	
func get_sfx_volume_db() -> float:
	return sfx_volume_db

# Set the music volume
func set_music_volume(new_volume_db: float):
	music_volume_db = new_volume_db
	save_settings()

# Set the SFX volume
func set_sfx_volume(new_volume_db: float):
	sfx_volume_db = new_volume_db
	save_settings()
	
# Save volume settings to a file
func save_settings():
	var config = ConfigFile.new()  # Updated for Godot 4
	config.set_value("audio", "music_volume", music_volume_db)
	config.set_value("audio", "sfx_volume", sfx_volume_db)
	var error = config.save("user://audio_settings.cfg")
	if error != OK:
		print("Failed to save audio settings: ", error)

# Load volume settings from a file
func load_settings():
	var config = ConfigFile.new()  # Updated for Godot 4
	var error = config.load("user://audio_settings.cfg")
	if error == OK:
		music_volume_db = config.get_value("audio", "music_volume", 0.0)
		sfx_volume_db = config.get_value("audio", "sfx_volume", 0.0)
	else:
		print("Failed to load audio settings, using default values: ", error)
