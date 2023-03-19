extends Control



func _on_ExitButton_pressed():
	get_tree().quit()


func _on_PlayButton_pressed():
	get_tree().change_scene_to_file("res://MainScene.tscn")
