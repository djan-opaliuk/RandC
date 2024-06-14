extends Sprite2D

@onready var task_manager_window = get_node("/root/Game/Canvas/TaskManagerWindow")  # Update this path to match your actual path to the FishingWindow node

func _ready():
	region_rect = Rect2(Vector2(0, 112), Vector2(16, 16))  # Task Butonunun Atlastaki yeri

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			print("Mouse button pressed")
			region_rect.position = Vector2(64, 128)  # Atlaste yer değiştiriyoruz
			task_manager_window.visible = true  # Balıkçı ekranını görüntülüyor.
		else:
			print("Mouse button released")
			region_rect.position = Vector2(64, 112)  # Atlasda normal yerine dönüyor.
