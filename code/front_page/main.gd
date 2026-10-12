extends Node2D



func _on_start_bt_pressed() -> void:
	get_tree().change_scene_to_file("res://letter_transition.tscn")
