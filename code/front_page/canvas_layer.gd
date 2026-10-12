extends CanvasLayer

@export var para_streth:float = 50.0;
@export var smooth_spd:float = 5.0;

@onready var camera = $Camera2D

func _process(delta: float) -> void:
	var screen_size = get_viewport().get_visible_rect().size
	var mouse_pos = get_viewport().get_mouse_position()
	mouse_pos.x = clamp(mouse_pos.x,40.0,screen_size.x-40.0)
	mouse_pos.y = clamp(mouse_pos.y,40.0,screen_size.y-40.0)
	var distance_center = (mouse_pos / screen_size) - Vector2(0.5,0.5)
	
	var scroll_amount = distance_center * para_streth
	
	#distance_center = distance_center.slerp(0.1*scroll_amount,smooth_spd*delta)
	distance_center = scroll_amount * 0.01
	
	camera.offset = distance_center
	#print(distance_center)
	
