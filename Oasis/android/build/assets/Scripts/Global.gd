extends Node2D

var windowHeight: int = ProjectSettings.get_setting("display/window/size/viewport_height")
var windowWidth: int = ProjectSettings.get_setting("display/window/size/viewport_width")
var updateRiver: bool = false
#if the game is in androids focus
var focused: bool = true


func _notification(what):
	if what == MainLoop.NOTIFICATION_APPLICATION_FOCUS_IN:
		focused = true
	elif what == MainLoop.NOTIFICATION_APPLICATION_FOCUS_OUT:
		focused = false
