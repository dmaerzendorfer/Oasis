extends Node2D


func _on_collision_checker_ray_2d_hit_by_river(object):
	if(object == %Goal.get_node("Hexagon/Area2D")):
		$"/root/SfxPlayer".playWinSound()
		Global.updateRiver = false
		fadeInLevelOver()
		
		
func fadeInLevelOver():
	var tween = create_tween()
	%WinUi.visible = true
	%WinUi.apply_scale(Vector2(0,0))
	tween.tween_property(%WinUi, "scale",Vector2(1,1),0.5).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
		
func loadMenu():
	print_debug("loading menu")
	get_tree().change_scene_to_file("res://Scenes/game.tscn")


func _on_button_pressed():
	$"/root/SfxPlayer".playClickSound()
	loadMenu()

#after the win
func _on_back_pressed():
	$"/root/SfxPlayer".playClickSound()
	loadMenu()
