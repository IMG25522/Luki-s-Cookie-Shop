extends Node

var text_speed = 0.1

var blank_texture: ImageTexture

var day = 1

@onready var supply = {
	1:[
		ingradient.new("flour"),
		ingradient.new("flour"),
		ingradient.new("flour"),
		ingradient.new("cranberry"),
		ingradient.new("chocolate"),
		ingradient.new("peanut"),
		item.new("knife"),
	],
	2:[
		ingradient.new("flour"),
		ingradient.new("flour"),
		ingradient.new("flour"),
		ingradient.new("flour"),
		ingradient.new("flour"),
		ingradient.new("flour"),
		ingradient.new("cranberry"),
		ingradient.new("chocolate"),
		ingradient.new("peanut"),
		item.new("injection"),
	],
	3:[
		ingradient.new("flour"),
		ingradient.new("flour"),
		ingradient.new("flour"),
		ingradient.new("flour"),
		ingradient.new("flour"),
		ingradient.new("chocolate"),
		ingradient.new("chocolate"),
		ingradient.new("peanut"),
		item.new("injection"),
		item.new("injection"),
	],
	4:[
		ingradient.new("flour"),
		ingradient.new("flour"),
		ingradient.new("flour"),
		ingradient.new("flour"),
		ingradient.new("flour"),
		ingradient.new("flour"),
		ingradient.new("cranberry"),
		ingradient.new("cranberry"),
		ingradient.new("chocolate"),
		item.new("injection"),
		item.new("injection"),
	],
	5:[
		ingradient.new("flour"),
		ingradient.new("flour"),
		ingradient.new("flour"),
		ingradient.new("flour"),
		ingradient.new("flour"),
		ingradient.new("flour"),
		ingradient.new("flour"),
		ingradient.new("cranberry"),
		ingradient.new("peanut"),
		ingradient.new("peanut"),
		ingradient.new("peanut"),
		ingradient.new("peanut"),
		item.new("injection"),
		item.new("injection"),
		item.new("injection"),
	],
	6:[
		ingradient.new("flour"),
		ingradient.new("flour"),
		ingradient.new("flour"),
		ingradient.new("flour"),
		ingradient.new("flour"),
		ingradient.new("cranberry"),
		ingradient.new("cranberry"),
		ingradient.new("peanut"),
		ingradient.new("chocolate"),
		ingradient.new("cranberry"),
	]
}
@onready var motd = {
	1:"You got in ingradients for today, now you can put them on the bread board, then oven, the sale!",
	2:"You don't know the former tenant, but unfortunately, you got somthing weird in the mailbox...",
	3:"The air feels fresh outside.",
	4:"It's a sunny day.",
	5:"It's a cloudy day.",
	6:"It's the last day, did you collect enough cash?",
}

var name_bin = [
	"Sunny",
	"Evans",
	"Eason",
	"Michael",
	"Christain",
	"Foggy",
	"Sandy",
	"Lordova",
	"Smoothie",
	"Expie",
	"Puro",
	"Lee",
	"Danny",
]

@onready var cookie_kinds = [
	"chocolate_cookie",
	"cranberry_cookie",
	"peanut_cookie",
	"original_cookie"
]

@onready var char_kinds = [
	{
		"happy":load("res://assets/images/chars/random/cat_1_happy.PNG"),
		"upset":load("res://assets/images/chars/random/cat_1_upset.PNG")
	},
	{
		"happy":load("res://assets/images/chars/random/deer_1_happy.PNG"),
		"upset":load("res://assets/images/chars/random/deer_1_upset.PNG")
	},
	{
		"happy":load("res://assets/images/chars/random/wolf_1_happy.PNG"),
		"upset":load("res://assets/images/chars/random/wolf_1_upset.PNG")
	}
]


@onready var customer_queue={
	1:[ # DAY I
		customer.new(name_bin.pick_random(),cookie_kinds.pick_random(),char_kinds.pick_random()),
		customer.new(name_bin.pick_random(),cookie_kinds.pick_random(),char_kinds.pick_random()),
		customer.new(name_bin.pick_random(),cookie_kinds.pick_random(),char_kinds.pick_random())
	],
	2:[ # DAY II
		customer.new(name_bin.pick_random(),cookie_kinds.pick_random(),char_kinds.pick_random()),
		customer.new(name_bin.pick_random(),cookie_kinds.pick_random(),char_kinds.pick_random()),
		customer.new(name_bin.pick_random(),cookie_kinds.pick_random(),char_kinds.pick_random()),
		customer.new(name_bin.pick_random(),cookie_kinds.pick_random(),char_kinds.pick_random()),
		customer.new(name_bin.pick_random(),cookie_kinds.pick_random(),char_kinds.pick_random()),
	],
	3:[ # DAY III
		customer.new(name_bin.pick_random(),cookie_kinds.pick_random(),char_kinds.pick_random()),
		customer.new(name_bin.pick_random(),cookie_kinds.pick_random(),char_kinds.pick_random()),
		customer.new(name_bin.pick_random(),cookie_kinds.pick_random(),char_kinds.pick_random()),
		customer.new(name_bin.pick_random(),cookie_kinds.pick_random(),char_kinds.pick_random()),
		customer.new(name_bin.pick_random(),cookie_kinds.pick_random(),char_kinds.pick_random()),
		customer.new(name_bin.pick_random(),cookie_kinds.pick_random(),char_kinds.pick_random()),
	],
	4:[ # DAY IV
		customer.new(name_bin.pick_random(),cookie_kinds.pick_random(),char_kinds.pick_random()),
		customer.new(name_bin.pick_random(),cookie_kinds.pick_random(),char_kinds.pick_random()),
		customer.new(name_bin.pick_random(),cookie_kinds.pick_random(),char_kinds.pick_random()),
		customer.new(name_bin.pick_random(),cookie_kinds.pick_random(),char_kinds.pick_random()),
		customer.new(name_bin.pick_random(),cookie_kinds.pick_random(),char_kinds.pick_random()),
		customer.new(name_bin.pick_random(),cookie_kinds.pick_random(),char_kinds.pick_random()),
		customer.new(name_bin.pick_random(),cookie_kinds.pick_random(),char_kinds.pick_random()),
	],
	5:[ # DAY V
		customer.new(name_bin.pick_random(),cookie_kinds.pick_random(),char_kinds.pick_random()),
		customer.new(name_bin.pick_random(),cookie_kinds.pick_random(),char_kinds.pick_random()),
		customer.new(name_bin.pick_random(),cookie_kinds.pick_random(),char_kinds.pick_random()),
		customer.new(name_bin.pick_random(),cookie_kinds.pick_random(),char_kinds.pick_random()),
		customer.new(name_bin.pick_random(),cookie_kinds.pick_random(),char_kinds.pick_random()),
		customer.new(name_bin.pick_random(),cookie_kinds.pick_random(),char_kinds.pick_random()),
		customer.new(name_bin.pick_random(),cookie_kinds.pick_random(),char_kinds.pick_random()),
		customer.new(name_bin.pick_random(),cookie_kinds.pick_random(),char_kinds.pick_random()),
	],
	6:[ # DAY VI
		customer.new(name_bin.pick_random(),cookie_kinds.pick_random(),char_kinds.pick_random()),
		customer.new(name_bin.pick_random(),cookie_kinds.pick_random(),char_kinds.pick_random()),
		customer.new(name_bin.pick_random(),cookie_kinds.pick_random(),char_kinds.pick_random()),
		customer.new(name_bin.pick_random(),cookie_kinds.pick_random(),char_kinds.pick_random()),
		customer.new(name_bin.pick_random(),cookie_kinds.pick_random(),char_kinds.pick_random()),
		customer.new(name_bin.pick_random(),cookie_kinds.pick_random(),char_kinds.pick_random()),
		customer.new(name_bin.pick_random(),cookie_kinds.pick_random(),char_kinds.pick_random()),
		customer.new(name_bin.pick_random(),cookie_kinds.pick_random(),char_kinds.pick_random()),
		customer.new(name_bin.pick_random(),cookie_kinds.pick_random(),char_kinds.pick_random()),
	]
}


func _ready():
	var img: Image = Image.create(64, 64, false, Image.FORMAT_RGBA8)
	img.fill(Color(0,0,0,0))
	blank_texture = ImageTexture.create_from_image(img)




func sleep(s):
	await get_tree().create_timer(s).timeout

func get_itid_path(itid_):
	return "res://assets/images/items/" + itid_ + ".PNG"

func get_item_list_selected(item_list):
	return item_list.get_selected_items()[0] if len(item_list.get_selected_items()) > 0 else -1

class item:
	var icon: Texture2D
	var itid: String
	func _init(itid_: String):
		var icon_path = pub.get_itid_path(itid_)
		icon = load(icon_path)
		itid = itid_
	
	
class ingradient extends item:
	"""Ingradient, to make into doughs"""
	var make_into
	func _init(itid: String):
		if(itid != "flour"):
			make_into = dough.new(itid.split("_")[0]+"_dough")
		else:
			make_into = dough.new("original_dough")
		super(itid)

class dough extends item:
	"""Dough, to cook into coockie"""
	var cook_into
	func _init(itid: String):
		cook_into = cookie.new(itid.split("_")[0]+"_cookie",randi_range(4,7))
		super(itid)
		

class cookie extends item: 
	"""Cookie, to sell"""
	var price: float
	func _init(itid: String, price_: float):
		super(itid)
		price = price_



class customer:
	"""Customer, buyers"""
	var images: Dictionary
	var rq_itid: String
	var char_name
	func _init(char_name_:String, rq_itid_:String, images_:Dictionary) -> void:
		char_name = char_name_
		rq_itid = rq_itid_
		images = images_
		


func lim_add(var1,toadd,lim):
	return var1+toadd if var1+toadd < lim else lim
