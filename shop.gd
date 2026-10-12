extends Node2D


@onready var in_shop_layer = $InShop
@onready var look_out_layer = $LookOut
@onready var over_lay_layer = $Overlay

@onready var msg =$Overlay/MessageBox
@onready var choice = $Overlay/ChoiceBox
@onready var inventory_disp = $Overlay/Inventory
@onready var bread_board = $InShop/BreadBoardLayer
@onready var oven = $InShop/OvenLayer
@onready var customer_disp = $LookOut/Customer
@onready var end_day_bt = $InShop/EndDayBt

@onready var luki =$InShop/Luki
@onready var control_bts = $Overlay/ControlBts
@onready var energy_disp = $Overlay/EnergyBar
@onready var health_disp = $Overlay/HealthBar
@onready var cash_disp   = $Overlay/CashBar
@onready var day_lb = $Overlay/DayLb

@onready var dark = $Overlay/Dark
#@onready var


var inventory = []
var max_energy = 15
var energy = 15
var max_health = 100
var gameover_health = 30
var health = 100
var requested_cash = 100
var cash = 0
var interaction_lock = false
var injection_usage = 0
var knife_usage = 0
var mail_box_checked_today = false

var current_case_solved = true
var current_customer:pub.customer
var now_at = "no_where" 
# at: "no_where", "bread_board", "oven", "front"

var walk_event = [
	"",
	"As you are walking, you meet a dragon, you don't know that there are dragons living here before. He greets you warmly, and explains that he is new to this town.",
	"A girl asks you for a cranberry, since she is allergic to gluten, she cannot have your cookies. You hand her a carnberry.",
	"You meet the customers Expie and Puro today, they told you that the taste of your cookies are fantastic, unlike the ones they use to have when they were on mission. [Dev Note: tribute to <CHANGED> and <Casualties: Unknown> for inspiration. ]",
	"The air is fresh, the sunset is beautiful.",
	"This afternoon is rainy, so you were staying in the library of the town reading books.",
	"",
]



func _ready() -> void:
	dark.modulate.a = 1.0
	dark.show()
	var dark_tween = create_tween()
	await dark_tween.tween_property(dark,"modulate:a", 0.0, 1.0)
	dark.hide()
	
	await msg.load_words("This is the shop.")
	await msg.load_words("Everyday, start with checking the mailbox(The black thing out the window, click), the new ingradients will be dilivered to you.")
	await msg.load_words("Your inventory is at the bottom of the window.")
	await msg.load_words("The bread board is where you make the doughs of cookies.")
	await msg.load_words("The oven is for bake.")
	await msg.load_words("When the bread board or oven is open, click the items on inventory to put them into process, click on the result to collect them.")
	await msg.load_words("After you've done them all and get the cookie, click the red bar on the left bottom corner to turn to the front side of your shop and try to sell them.")
	await msg.load_words("PAY ATTENTION TO THE THREE VALUE BARS ON THE TOP LEFT, \nONE IS ENERGY, YOU CANNOT DO ANYTHING WITHOUT IT, AND SINCE YOU HAVE DEPRESSION, IT\'S REALLY EASY FOR YOU TO GET TIRED. ")
	await msg.load_words("ANOTHER IS HEALTH, REMEMBER, TO LIVE.")
	await msg.load_words("THE LAST ONE IS CASH -- TRY TO FILL THE REQUIREMENTS(FILL OUT THE PROGRESS BAR) IN THESE 6 DAYS.")
	await msg.load_words("Good Luck, Luki.")

func _on_refresher_timeout() -> void:
	inventory_refresh()
	refresh_bars()
	if(health < max_health*0.3):
		game_over()
	day_lb.text = "DAY %s"%(pub.day)


func refresh_bars():
	health_disp.value = health
	energy_disp.value = energy
	cash_disp.value = cash

func inventory_refresh():
	var selected_index = pub.get_item_list_selected(inventory_disp)
	inventory_disp.clear()
	for i in inventory:
		inventory_disp.add_item(i.itid,i.icon)
	if(selected_index != -1):
		inventory_disp.select(selected_index)

func _on_oven_bt_pressed() -> void:
	if(energy > 0):
		change_at_to("oven",oven)


func _on_bread_board_pressed() -> void:
	if(energy > 0):
		change_at_to("bread_board",bread_board)

func _on_mail_box_bt_pressed() -> void:
	if(mail_box_checked_today):
		await msg.load_words("You've checked it today already.")
	else:
		mail_box_checked_today = true
		await msg.load_words(pub.motd[pub.day])
		inventory += pub.supply[pub.day]
		

func no_energy_notice():
	luki.play("tired")
	if(knife_usage + injection_usage == 0):
		await msg.load_words("I feel so tired... they said my depression caused it, but am I being lazy..? I want to rest...... ","You")
		var end_on_zero = await choice.ask_choices(["End day","Back"],"Up/Down Arrow and Enter")
		if(end_on_zero == 0):
			await end_day()
	elif(knife_usage + injection_usage > 1):
		await msg.load_words("I am so tired... I... I think there are ways to prevent myself from just being lazy..?","You")
		
func change_at_to(place,layer=null):
	if(now_at == "no_where" or place == "no_where"):
		now_at = place
		if(layer):
			layer.show()

func _on_inventory_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	print("INVENTORY CLICKED ")
	var still_have_energy = await decrease_energy( 1 )
	if(not still_have_energy):return
	if(now_at == "no_where"):
		control_bts.show()
	elif(now_at == "bread_board"):
		print("AT BREAD BOARD")
		if(inventory[pub.get_item_list_selected(inventory_disp)] is pub.ingradient):
			
			bread_board.feed(inventory[pub.get_item_list_selected(inventory_disp)])
			print("feed %s to breadboard"%(inventory[pub.get_item_list_selected(inventory_disp)].itid))
			inventory.remove_at(pub.get_item_list_selected(inventory_disp))
	elif(now_at == "oven"):
		print("AT OVEN")
		if(inventory[pub.get_item_list_selected(inventory_disp)] is pub.dough):
			oven.feed(inventory[pub.get_item_list_selected(inventory_disp)])
			print("feed %s to oven"%(inventory[pub.get_item_list_selected(inventory_disp)].itid))
			inventory.remove_at(pub.get_item_list_selected(inventory_disp))

func _on_inventory_focus_exited() -> void:
	await pub.sleep(0.3)
	control_bts.hide()


func _on_trash_bt_pressed() -> void:
	#print("_on_trash_bt_pressed call")
	var sel = pub.get_item_list_selected(inventory_disp)
	if(sel != -1):
		inventory.pop_at(sel)
		#print("POPED")

func _on_receive_item(item) -> void:
	inventory.append(item)
	


func _on_layer_quit() -> void:
	var still_have_energy = await decrease_energy( 1 )
	if(not still_have_energy):return
	change_at_to("no_where")


func _on_use_bt_pressed() -> void:
	print("use button pressed")
	if (now_at != "no_where"):
		return
	var thing = inventory[pub.get_item_list_selected(inventory_disp)]
	print(thing.itid)
	if(thing.itid == "knife"):
		knife_usage += 1
		if(knife_usage == 1):
			luki.play("crazy")
			await msg.load_words("The blade cuts into your arm, causing a small cut, not much blood,but enough for you to feel *something*")
			luki.play("sad")
			await msg.load_words("Do it feel... good ????????????", "You")
			luki.play("tired")
		else:
			await msg.load_words("Another cut on your thin arm.")
		health -= 5
		energy = pub.lim_add(energy,2,max_energy)
	elif(thing.itid == "injection"):
		inventory.pop_at(pub.get_item_list_selected(inventory_disp))
		injection_usage += 1
		if(injection_usage == 1):
			luki.play("crazy")
			await msg.load_words("It feels soooooooo goooood..... Ahhhhhhhhhhh......","You")
			luki.play("sad")
			await msg.load_words(".......", "You")
			luki.play("tired")
		elif(injection_usage > 1):
			luki.play("crazy")
			await msg.load_words("Soooooooo goooood..... I want more......","You")
			luki.play("sad")
			await msg.load_words(".......", "You")
			luki.play("tired")
		max_energy = max_energy-1 if max_energy > 5 else 5
		energy_disp.max_value = max_energy
		energy = max_energy
		health -= 5*injection_usage


func pop_cookie(itid_str):
	for i in range(len(inventory)):
		if(inventory[i].itid == itid_str):
			return inventory.pop_at(i)
	return null


func load_customer():
	if(pub.customer_queue[pub.day]):
		var customer_now = pub.customer_queue[pub.day].pop_back()
		customer_disp.texture = customer_now.images["happy"]
		return customer_now
	else:
		return null
	
func sell(customer):
	"""Reutrn bool, if the case is resolved"""
	await msg.load_words("May I have a %s"%(customer.rq_itid),customer.char_name)
	var c = await choice.ask_choices(["Hand the cookie","Reject","Please give me a minute to bake"],"Up/Down Arrow and Enter")
	var res = false
	if(c == 0):
		var still_have_energy = await decrease_energy( 1 )
		if(not still_have_energy):return
		var cookie_sold:pub.cookie = pop_cookie(customer.rq_itid)
		if(cookie_sold):
			await msg.load_words("Thank you.",customer.char_name)
			cash += cookie_sold.price
		else:
			customer_disp.texture = customer.images["upset"]
			await msg.load_words("You don't have the cookie though.",customer.char_name)
		res = true
	elif(c == 1):
		var still_have_energy = await decrease_energy( 1 )
		if(not still_have_energy):return
		await msg.load_words("Oh...",customer.char_name)
		customer_disp.texture = customer.images["upset"]
		await msg.load_words("I thought you have them.",customer.char_name)
		res = true
	elif(c == 2):
		pass
	if(res):
		customer_disp.texture = null
	return res
	
func load_and_sell():
	if(current_case_solved):
		current_customer = load_customer()
	if(current_customer):
		current_case_solved = await sell(current_customer)
	else:
		await msg.load_words("Seems no one else is comming today...")


var talk_blocked
func _on_talk_bt_pressed() -> void:
	if(not talk_blocked):
		talk_blocked = true
		await load_and_sell()
		talk_blocked = false

func _on_pull_bt_pressed() -> void:
	if(now_at == "no_where"):
		now_at = "front"
		look_out_layer.show()
		in_shop_layer.hide()
		load_and_sell()
		
	elif(now_at == "front"):
		now_at = "no_where"
		in_shop_layer.show()
		look_out_layer.hide()


func end_day():# ACCUALLY HANDLE THE DAY SWITCHING
	if(pub.day == 6):
		if(cash >= requested_cash):
			get_tree().change_scene_to_file("res://good_ending.tscn")
		else:
			get_tree().change_scene_to_file("res://mid_ending.tscn")
	dark.show()
	now_at = "no_where"
	oven.hide()
	bread_board.hide()
	look_out_layer.hide()
	in_shop_layer.show()
	end_day_bt.hide()
	
	var dark_tween_in = create_tween()
	dark_tween_in.tween_property(dark,"modulate:a", 1.0, 1.0)
	await dark_tween_in.finished
	
	await msg.load_words("You closed the window, this day is ended.")
	var walk = await choice.ask_choices(["Just, sleep","Go for a walk"],"You decided to...(Up/Down key + Enter/E)")
	if(walk == 1):
		max_energy += 2
		energy_disp.max_value = max_energy
		await msg.load_words(walk_event[pub.day])
	await msg.load_words("You got back to your bedroom, small but enough for you. Tomorrow is another day.")
	
	pub.day += 1
	
	luki.play("normal")
	
	var dark_tween_out = create_tween()
	dark_tween_out.tween_property(dark,"modulate:a", 0.0, 1.0)
	await dark_tween_out.finished
	dark.hide()
	end_day_bt.show()
	energy = max_energy
	mail_box_checked_today = false
	msg.load_words("DAY %s"%(pub.day))

func decrease_energy(amount:float):
	if(energy >= amount):
		energy -= amount
		return true
	else:
		await no_energy_notice()
		return false


func game_over():
	get_tree().change_scene_to_file("res://game_over.tscn")


func _on_end_day_bt_pressed() -> void:
	end_day()
