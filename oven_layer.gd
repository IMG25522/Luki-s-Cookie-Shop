extends CanvasLayer


@onready var grid_a = $Dough
@onready var grid_b = $Result
var result:pub.cookie = null
var item_a:pub.dough = null

signal give(item:pub.item)
signal quit()

func feed(item: pub.item):
	if(item is pub.dough):
		item_a = item


func _on_timer_timeout() -> void:
	var res_texture
	if(item_a):
		result = item_a.cook_into
		grid_a.texture_normal = item_a.icon
		grid_b.texture_normal = result.icon

func _on_result_pressed() -> void:
	if(result):
		give.emit(result)
		item_a = null
		result = null
		grid_a.texture_normal = null
		grid_b.texture_normal = null
		


func _on_dough_pressed() -> void:
	give.emit(item_a)
	item_a = null
	result = null
	grid_b.texture_normal = null
	grid_a.texture_normal = null


func _on_quit_bt_pressed() -> void:
	hide()
	quit.emit()
