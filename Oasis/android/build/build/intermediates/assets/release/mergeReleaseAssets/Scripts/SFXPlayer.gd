extends Node2D

var clickSound
var winSound
var pressReleaseSound

var audioFocus

func _ready():
	clickSound = preload("res://Sound/click.wav")
	winSound = preload("res://Sound/win.wav")
	pressReleaseSound = preload("res://Sound/pressRelease.wav")
	#resources for audio focus and android plugins:
	# https://www.youtube.com/watch?v=kwf8SFfH4s8
	# https://docs.godotengine.org/en/stable/tutorials/platform/android/android_plugin.html
	# https://developer.android.com/studio/projects/android-library#AddDependency
	print_debug("in sfx player ready")
	
	if Engine.has_singleton("AudioFocusPlugin"):
		audioFocus = Engine.get_singleton("AudioFocusPlugin")
		if audioFocus != null:
			audioFocus.connect("AudioFocusLoss",Callable(self,"on_AudioFocusLoss"))
			audioFocus.connect("AudioFocusGain",Callable(self,"on_AudioFocusGain"))
			audioFocus.connect("AudioFocusLossTransient",Callable(self,"on_AudioFocusLossTransient"))
			audioFocus.requestAudioFocus()

func _exit_tree():
	if audioFocus !=null:
		audioFocus.abandonAudioFocus()

func on_AudioFocusLossTransient():
	print_debug("audio focus lost transient")
	Settings.set_setting("audio","muteMusic", true)
	muteMusic()
	
func on_AudioFocusLoss():
	print_debug("audio focus lost")
	Settings.set_setting("audio","muteMusic", true)
	muteMusic()

func on_AudioFocusGain():
	print_debug("audio focus gained")	
	Settings.set_setting("audio","muteMusic", false)
	unmuteMusic()


func muteMusic():
	$"MusicPlayer".playing = false
	
func unmuteMusic():
	$"MusicPlayer".playing = true

func playClickSound():
	_playSound(clickSound)
	
func playWinSound():
	_playSound(winSound)
	
func playReleaseSound():
	_playSound(pressReleaseSound)
	
func _playSound(sound: AudioStream):
	#dont play audio if game is not focues
	if !Global.focused:
		pass
	var player = AudioStreamPlayer.new()
	add_child(player)
	player.stream = sound
	player.play()
	
	await player.finished
	remove_child(player)
