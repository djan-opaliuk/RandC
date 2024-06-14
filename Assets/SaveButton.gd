extends Sprite2D

func _ready():
	region_rect = Rect2(Vector2(0, 112), Vector2(16, 16))  # Buton  görselinin atlastaki yeri

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				print("Mouse button pressed")
				region_rect.position = Vector2(0, 128)  # Bölge değiştirme
				#Kaydetme işlemi implementasyonunu buraya ekleyeceğim.
				
				get_tree().quit()  # Oyunu kapatma
			else:
				print("Mouse button released")
				region_rect.position = Vector2(0, 112)  # Atlasta orjinal yerine dönüyor.
