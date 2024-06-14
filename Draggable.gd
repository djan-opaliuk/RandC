extends Node2D

#Değişken atamaları
var dragging = false
var drag_offset = Vector2.ZERO
var node_size = Vector2(200, 200)  

#Başlangıç Fonksiyonu
func _ready():
	set_process_input(true)

#Mouse Tıklama Sinyali, Ekranı sürüklemek içindir.
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if is_mouse_over():
					dragging = true
					drag_offset = global_position - get_global_mouse_position()
			else:
				dragging = false

	if event is InputEventMouseMotion and dragging:
		global_position = get_global_mouse_position() + drag_offset

#Mouse Öğenin Üzerinde mi?
func is_mouse_over():
	var mouse_position = get_global_mouse_position()
	var rect = Rect2(global_position - node_size / 2, node_size)
	return rect.has_point(mouse_position)

#Kapatma tuşu 
func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			self.visible = false
