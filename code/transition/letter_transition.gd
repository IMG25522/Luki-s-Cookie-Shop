extends Node2D

@onready var letter_paper = $LetterMom
@onready var dark_cover = $ColorRect2
@onready var msg = $MessageBox

var already_changed_scene = false

func _ready() -> void:
	dark_cover.modulate.a = 0.0
	
	var letter_tween = create_tween()
	letter_tween.tween_property(letter_paper,"position",letter_paper.position-Vector2(0,800),1.0)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)
	await letter_tween.finished
	
	await msg.load_words("A letter......\n* Press <Enter> or <E> to continue or skip...","You")
	await msg.load_words("Mom......","You")
	await msg.load_words("......","You")
	await msg.load_words("I... HATE ...... ","You")
	await msg.load_words("No, I'm fine...","You")
	
	var dark_in = create_tween()
	dark_in.tween_property(dark_cover,"modulate:a",1.0,1.0)
	await dark_in.finished
	
	await msg.load_words("By any metric, you are not a good kid in your parents' eyes.")
	await msg.load_words("In school you had a bad, if avoiding the word \"terrible\", performence.")
	await msg.load_words("And because of that, you failed to get into college.")
	await msg.load_words("Your parents don't have too much expectation on you. However, your failure to college did shock them.")
	await msg.load_words("You feel fear, stress and tirdness. You thought it's fine, until you got diagnosed that you've got depression.")
	await msg.load_words("By the way, you started to have your antlers already.")
	await msg.load_words("Luckily, you got something you like to do and can do really well: ")
	await msg.load_words("Baking cookies.")
	await msg.load_words("Even though depression makes you feel tired much quicker than others, and make the ones don't know you think you are so lazy, you still started a cookie shop.")
	await msg.load_words("The landlord (owner) of the shop house gives you 6 days to proof your ability to make money, if you could make him believe that you worth, you would grant a longer cooperation with him.")
	await msg.load_words("Are you ready, Luki?")
	if(not already_changed_scene):
		get_tree().change_scene_to_file("res://shop.tscn")
	


func _on_skip_bt_pressed() -> void:
	already_changed_scene = true
	get_tree().change_scene_to_file("res://shop.tscn")
