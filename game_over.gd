extends Node2D

@onready var msg = $MessageBox
@onready var dark = $ColorRect
@onready var back_bt = $Button

func _ready() -> void:
	await msg.load_words("Dark flashes in your eyes, you falls to the ground almost in a sudeen.",null,null,false,true,2,true)
	await msg.load_words("The injections and cuts, and everything you used to keep yourself from being lazy......",null,null,false,true,2,true)
	await msg.load_words("Your body is tired. Depression and something together is dragging you down.",null,null,false,true,2,true)
	await msg.load_words("..................",null,null,false,true,1,true)
	var dark_out = create_tween()
	dark_out.tween_property(dark,"modulate:a",0.0,3.0)
	await dark_out.finished
	dark.hide()
	back_bt.show()
	
	


func _on_button_pressed() -> void:
	await msg.load_words("GAME OVER, REFRESH PAGE TO REPLAY.")
	get_tree().quit()
	
