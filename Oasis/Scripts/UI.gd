extends Node2D


func fadeOut():
	var tween = create_tween()
	tween.tween_property(self, "modulate",Color(1,1,1,0),0.5).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(loadLevel)

func _on_start_button_pressed():
	$"/root/SfxPlayer".playClickSound()
	move(%Start,Vector2(Global.windowWidth,0))
	fadeOut()

func loadLevel():
	get_tree().change_scene_to_file("res://Scenes/Level1.tscn")


func _on_quit_button_pressed():
	Settings.save_settings()
	get_tree().quit()


func _on_options_pressed():
	$"/root/SfxPlayer".playClickSound()
	#move start out
	move(%Start,Vector2(-Global.windowWidth,0))
	#make settings visible
	%Settings.visible=true

func _on_back_button_pressed():
	$"/root/SfxPlayer".playClickSound()
	#move start back in
	#make settings invisible once done
	move(%Start,Vector2(0,0)).tween_callback(func(): 
		%Settings.visible = false
		)

#just a helper function to move things with a tween
func move(node, target):
	var tween = create_tween()
	tween.tween_property(node, "position",target,2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	return tween
