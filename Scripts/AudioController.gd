extends Node

# Volume levels for different categories
var music_volume_db: float
var sfx_volume_db: float

# AudioStreamPlayer nodes for music and SFX
@onready var music_player: AudioStreamPlayer2D = $MusicPlayer
@onready var sfx_player: AudioStreamPlayer2D = $SFXPlayer

func _ready():
	load_settings()

func play_sound(stream: AudioStream):
	var instance = AudioStreamPlayer2D.new()
	instance.stream = stream
	instance.finished.connect(remove_node.bind(instance))
	add_child(instance)
	instance.play()
	
func remove_node(instance: AudioStreamPlayer2D):
	instance.queue_free()

func get_music_volume_db() -> float:
	return music_volume_db
	
func get_sfx_volume_db() -> float:
	return sfx_volume_db

# Play background music with the current volume setting
func play_music(stream: AudioStream, loop: bool = true):
	music_player.stream = stream
	music_player.loop = loop
	music_player.volume_db = music_volume_db  # Apply music volume
	music_player.play()

# Play a sound effect with the current volume setting
func play_sfx(stream: AudioStream):
	sfx_player.stream = stream
	sfx_player.volume_db = sfx_volume_db  # Apply SFX volume
	sfx_player.play()

# Set the music volume
func set_music_volume(new_volume_db: float):
	music_volume_db = new_volume_db
	music_player.volume_db = music_volume_db  # Update music player volume
	save_settings()

# Set the SFX volume
func set_sfx_volume(new_volume_db: float):
	sfx_volume_db = new_volume_db
	sfx_player.volume_db = sfx_volume_db  # Update SFX player volume
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
		# Update the AudioStreamPlayer volumes to match loaded settings
		music_player.volume_db = music_volume_db
		sfx_player.volume_db = sfx_volume_db
	else:
		print("Failed to load audio settings, using default values: ", error)
