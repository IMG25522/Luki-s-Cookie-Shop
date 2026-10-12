extends Button

@export var per_spd := 0.04 #the speed of per one character popping out
var current_loading_thing := ""
var fulled := false
var controlable := true
@onready var messager = $Container/FrameLessMessage
@onready var dot_blinking_label = $DotLabel
signal finish
var load_locked = false # incase if there are another element requires interact key(ex. as interacting with words only itms, the "pressing to interact" itself could lead to unexpected words fulling)
#var test_image = preload("res://images/character_item/f242_head.png")


func _ready():
	pass
	#TEST:
	#await load_words("Hello!\nWorld!!")
	#print("A")
	#await load_words("12345678901234567890123456789012345678901234567890123456789012345678901234567890","Name")
	#print("B")
	#await load_words("backspace test",null,null,false,true,0.3)
	#print("C")
	#await load_words("1234567890876543","Name",null,false,true,0.3)
	#print("D")
	#await load_words("hand! hand! hand! hand! hand! hand! hand! hand! hand! hand! hand! hand! hand! hand! hand! hand! hand!","Name")
	#print("E")


func _unhandled_input(event: InputEvent) -> void:
	if(len(messager.text) > 1):
		if(event.is_action_released("interact") and controlable):
			_on_pressed()
			#print("!-- load_locked:",load_locked)

#func _ready():
	#await load_words("fghvjksdklaebsdiuljfh9udihsvuifdjhvuishdviushdfviufdjshdfiujvlkhsiudfjhviusudfhvuishdfiuvhssuidfvhudsihvfciudsfvhjodisjfvioshkdiausdfgahd")
	#await load_words("123423456743ewf45678","FB",test_image

			
			
			

func load_words(thing,char_name=null,char_image=null,user_can_control=true,remove_w_backspace=false,auto_end_delay=-1,over_ride_text_spd=false):# char_image should be a ImageTexture # EXPOSHA PORT
	# !: <auto_donw_delay> means it will be "end()" after the delayed time (the delayed time count start the "full" event), if is negtive, then auto done is diabled
	if(over_ride_text_spd):
		messager.per_spd = per_spd
	else:
		messager.per_spd = per_spd * (1 - pub.text_speed)
	
	if(user_can_control != controlable):
		controlable = user_can_control
	#print("controllable:",controlable)
	if (not load_locked):
		load_locked = true
		if(messager.text):
			end()
		fulled = false
		clear()
		if(char_image):
			$HeadImage.texture = char_image
			$HeadImage.show()
			messager.size.x = 1248
			messager.position.x = 288
		else:
			$HeadImage.hide()
			messager.size.x = 1536
			messager.position.x = 0
		
		dot_blinking_label.visible = false
		if(char_name):
			thing = "["+char_name+"]\n"+thing
			
		visible = true
		current_loading_thing = thing
		#print("set current loading:",current_loading_thing)
		messager.load_words(thing)
		await messager.done
		if(auto_end_delay >= 0):
			auto_ender(auto_end_delay,remove_w_backspace)
		fulled = true
		await finish
		await end(remove_w_backspace)
		load_locked = false
		print("Fine.")
	

func auto_ender(delay=-1,remove_w_backspace=false):
	if(delay<0):
		return
	await pub.sleep(delay)
	finish.emit()
	

func load_full():
	fulled = true
	messager.load_full(current_loading_thing)

func clear():
	current_loading_thing = ""
	messager.clear()
	$HeadImage.texture = null

func end(remove_w_backspace=false):
	#print("END!")
	if(remove_w_backspace):
		await remove_backspace()
	current_loading_thing = ""
	visible = false
	$HeadImage.visible = false
	finish.emit()
	fulled = false
	#controlable = true
	clear()

func _on_timer_timeout() -> void:#on blink timer time out
	if(fulled):
		dot_blinking_label.visible = not dot_blinking_label.visible


func _on_pressed() -> void:
	if(load_locked and controlable):
		#print("REACT!!")
		react_to_fulling()

func react_to_fulling():
	if(not fulled):
		#print("LOAD FULL!!:")
		load_full()
	else:
		print("EMIT FINISH!!")
		finish.emit()

func remove_backspace(delay=0.02):
	"""remove all the characters like pressing backspace 
	again and again with a gap time of <delay>"""
	for i in range(len(messager.text)):
		messager.load_full(messager.text.substr(0,len(messager.text)-1)) 
		await pub.sleep(delay)
	


#func _process(delta: float) -> void:
	#print("COntrolable:",controlable," fulled:",fulled," load_locked:",load_locked)
