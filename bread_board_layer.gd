extends CanvasLayer

@onready var grid_a = $Flour
@onready var grid_b = $Addon
@onready var grid_c = $Result
var result:pub.dough = null
var item_a:pub.ingradient = null
var item_b:pub.ingradient = null

signal give(item:pub.item)
signal quit()

func feed(item: pub.item):
	if(item.itid == "flour"):
		item_a = item
	else:
		item_b = item
	
		

func _on_timer_timeout() -> void:
	var res_texture
	if(item_a):
		result = item_a.make_into
		grid_a.texture_normal = item_a.icon
		grid_c.texture_normal = result.icon
	if(item_b):
		grid_b.texture_normal = item_b.icon
	if(item_a and item_b):
		result = item_b.make_into
		#print(item_b.make_into.itid)
		grid_c.texture_normal = result.icon

func _on_result_pressed() -> void:
	if(result):
		give.emit(result)
		item_a = null
		item_b = null
		result = null
		grid_a.texture_normal = null
		grid_b.texture_normal = null
		grid_c.texture_normal = null
		



func _on_flour_pressed() -> void:
	give.emit(item_a)
	item_a = null
	grid_a.texture_normal = null
	

func _on_addon_pressed() -> void:
	give.emit(item_b)
	item_b = null
	grid_b.texture_normal = null


func _on_quit_bt_pressed() -> void:
	hide()
	quit.emit()
