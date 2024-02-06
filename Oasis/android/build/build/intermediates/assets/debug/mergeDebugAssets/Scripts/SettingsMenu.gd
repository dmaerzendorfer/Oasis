extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	#load settings
	%MuteMusic.button_pressed = Settings.get_setting("audio","muteMusic")
	%UseGyro.button_pressed = Settings.get_setting("gameplay","useGyro")
	
