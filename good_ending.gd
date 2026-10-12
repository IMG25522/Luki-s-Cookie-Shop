extends Node2D

@onready var msg = $MessageBox
@onready var dark = $ColorRect
@onready var back_bt = $Button

func _ready() -> void:
	await msg.load_words("You did it.",null,null,false,true,2,true)
	await msg.load_words("Through the 6 days you've proved that you can be a successful cookie baker.",null,null,false,true,2,true)
	await msg.load_words("You have overcame your laziness, and your depression seem to be not that serious.",null,null,false,true,2,true)
	await msg.load_words("The sun rises, you know that's a sign for your new beginning.",null,null,false,true,2,true)
	var dark_out = create_tween()
	dark_out.tween_property(dark,"modulate:a",0.0,3.0)
	await dark_out.finished
	dark.hide()
	back_bt.show()
	
	


func _on_button_pressed() -> void:
	await msg.load_words("GAME OVER, REFRESH PAGE TO REPLAY.")
	get_tree().quit()
	
