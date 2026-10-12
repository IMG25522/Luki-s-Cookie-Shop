extends Button

var per_spd := 0.01 #the speed of per one character popping out
var current_loading_thing := ""
var fulled := false
var selection_movement = 0
var choices:Array
var asking_input = false
@onready var messager = $VBoxContainer/FrameLessMessage
@onready var dot_blinking_label = $DotLabel
signal finish
var locked = false

@onready var item_list = $VBoxContainer/ItemList

#var test_image = preload("res://images/character_item/f242_head.png")

func _ready():
	messager.per_spd = per_spd
	#print(len([1,2,3,4]))
	##TEST:
	#print(await ask_choices(["A","B","C","D"],"WORDS","CHARNAME"))
	#print(await ask_choices(["A","B","C","D"],"WORDS 2 WORDS 2 WORDS 2 WORDS 2 WORDS 2 WORDS 2 WORDS 2 WORDS 2 WORDS 2 WORDS 2 WORDS 2 WORDS 2 WORDS 2"))

func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("interact")):
		if(not fulled):
			load_full()
		else:
			finish.emit()

#func _ready():
	#await load_words("fghvjksdklaebsdiuljfh9udihsvuifdjhvuishdviushdfviufdjshdfiujvlkhsiudfjhviusudfhvuishdfiuvhssuidfvhudsihvfciudsfvhjodisjfvioshkdiausdfgahd")
	#await load_words("123423456743ewf45678","FB",test_image

			
			
			

func ask_choices(choices:Array,words="",char_name=null):# char_image should be a ImageTexture # EXPOSHA PORT
	messager.per_spd = per_spd * (1 - pub.text_speed)
	if(locked):
		return
	locked = true
	clear()
	dot_blinking_label.visible = false
	if(char_name):
		words = "["+char_name+"]\n"+words
		
	visible = true
	current_loading_thing = words
	messager.load_words(words)
	await messager.done
	fulled = true
	print("Start selecing")
	var choice_index = await ask_choice_input(choices)
	print("selecting Fine.")
	end()
	locked = false
	return choice_index
	
func ask_choice_input(choices:Array):
	for i in choices:
		item_list.add_item(i)
	var current_hover_index = 0
	item_list.select(current_hover_index)
	var update_trigger = false
	asking_input = true
	item_list.show()
	while(1):
		await $Timer_2.timeout
		if(selection_movement):
			#print("select mov:",selection_movement)
			if(selection_movement == 127):
				selection_movement = 0
				break
			current_hover_index = plus_in_scope(current_hover_index,selection_movement,0,len(choices)-1)
			item_list.select(current_hover_index)
			selection_movement = 0
	item_list.clear()
	#print("selected item:",current_hover_index)
	return current_hover_index
	
func _input(event: InputEvent) -> void:
	if(asking_input and locked):
		if(Input.is_action_just_pressed("up")):
			selection_movement = -1
		elif(Input.is_action_just_pressed("down")):
			selection_movement = 1
		elif(Input.is_action_just_pressed("interact")):
			selection_movement = 127# means quit


func plus_in_scope(ori,num,smallest,biggest):
	var res
	if(ori+num > biggest):
		res = smallest + ((ori+num)-biggest-1)
	elif(ori+num < smallest):
		res = biggest - (smallest-(ori+num)-1)
	else:
		res = ori+num
	return res

func load_full():
	fulled = true
	messager.load_full(current_loading_thing)

func clear():
	current_loading_thing = ""
	messager.clear()

func end():
	visible = false
	item_list.visible = false
	finish.emit()
	fulled = false
	selection_movement = 0
	asking_input = false
	locked = false
	await clear()

func _on_timer_timeout() -> void:#on blink timer time out
	if(fulled):
		dot_blinking_label.visible = not dot_blinking_label.visible


func _on_pressed() -> void:
	if(not fulled):
		load_full()
	else:
		finish.emit()
