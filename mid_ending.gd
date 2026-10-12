extends Node2D

@onready var msg = $MessageBox
@onready var dark = $ColorRect
@onready var back_bt = $Button

func _ready() -> void:
	await msg.load_words("You failed.",null,null,false,true,2,true)
	await msg.load_words("Some what, laziness, depression and something else had made you not motivated. ",null,null,false,true,2,true)
	await msg.load_words("The landlord ask you to move out, and you got no choice.",null,null,false,true,2,true)
	await msg.load_words("You don't know what is going to happen to your life. Your illness seems to be worse, however, you still need to face the sun rise.",null,null,false,true,2,true)
	var dark_out = create_tween()
	dark_out.tween_property(dark,"modulate:a",0.0,3.0)
	await dark_out.finished
	dark.hide()
	back_bt.show()
	
	


func _on_button_pressed() -> void:
	await msg.load_words("GAME OVER, REFRESH PAGE TO REPLAY.")
	get_tree().quit()
	
