extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	#read settings and set in ui
	loadSettings()

func loadSettings():
	%UseGyro.button_pressed = Settings.get_setting("gameplay","useGyro")
	%MuteMusic.button_pressed = Settings.get_setting("audio","muteMusic")

func _on_use_gyro_toggled(button_pressed):
	$"/root/SfxPlayer".playClickSound()
	Settings.set_setting("gameplay","useGyro", button_pressed)
	Settings.save_settings()
	


func _on_mute_music_toggled(button_pressed):
	$"/root/SfxPlayer".playClickSound()
	Settings.set_setting("audio","muteMusic", button_pressed)
	Settings.save_settings()
	if button_pressed:
		$"/root/SfxPlayer".muteMusic()
	else:
		$"/root/SfxPlayer".unmuteMusic()



func _on_visibility_changed():
	loadSettings()
