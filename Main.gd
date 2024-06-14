extends Node2D

#Referanslar
@onready var collision_shapes = []
@onready var timer = $"Pomodoro/Node2D"
@onready var task_manager = $TaskManagerWindow
@onready var fish_manager = $FishingWindow/Fishes

#Başlangıç Fonksiyonu
func _ready():
	setup_window()
	gather_collision_shapes()
	update_click_polygons()
	timer.connect("task_finished", Callable(self, "_on_task_finished"))

#Pencere Ayarlarının kurulumu
func setup_window():
	#Ana ekranın çözünürlünün alınması.
	var primary_screen_index = 0
	var screen_size = DisplayServer.screen_get_size(primary_screen_index)
	var screen_position = DisplayServer.screen_get_position(primary_screen_index)

	#Transparan ve arkaya tıklama özellikleri için ayarların yapılması. 
	#Tüm ayarları doğru yapmama rağmen prototipimde çalışırken proje ilerleyince çalışmamaya başladı. 
	#Bu siyah ekran sorununu çözemedim. Benzer sorun yaşayanları da gördüm forumlarda, Godot ile ilgili bir durum olduğunu
	#ve düzeleceğini düşünüyorum. 
	var window = get_window()
	window.borderless = true
	window.always_on_top = true
	window.size = screen_size
	window.position = screen_position
	window.transparent_bg = true  
	window.transparent = true


func _process(delta):
	update_click_polygons()

#Ekrandaki her bir objenin Polygon şekillerini bir listede topluyorum. 
func gather_collision_shapes():
	for child in self.get_children():
		if child.has_node("Area2DShape/Shape"):
			var shape = child.get_node("Area2DShape/Shape")
			if shape is CollisionShape2D:
				collision_shapes.append(shape)
	print("Toplanan şekil sayısı: ", collision_shapes.size())

#Tıklanabilir alandaki polygonların alanlarını güncelliyorum.
func update_click_polygons():
	var passthrough_polygon = PackedVector2Array()
	for shape in collision_shapes:
		var rect = calculate_global_bounding_box(shape)
		passthrough_polygon.append(rect.position)
		passthrough_polygon.append(rect.position + Vector2(rect.size.x, 0))
		passthrough_polygon.append(rect.position + rect.size)
		passthrough_polygon.append(rect.position + Vector2(0, rect.size.y))
	print("Polygon Sayısı: ", passthrough_polygon)
	get_window().mouse_passthrough_polygon = passthrough_polygon

#Canvastan tıklanabilir bölgedeki polygonları çıkarıyorum. 
func calculate_global_bounding_box(collision_shape) -> Rect2:
	var shape = collision_shape.shape
	if shape is RectangleShape2D:
		var extents = shape.extents
		var global_position = collision_shape.global_transform.origin - extents  
		return Rect2(global_position, extents * 2)
	return Rect2(collision_shape.global_transform.origin, Vector2())

#Maskotu ekranda köşede başlatıyorum. 
func place_mascot():
	var mascot = get_node("Mascot")
	var margin = Vector2(50, 50)
	mascot.position = Vector2(get_window().size.x - mascot.texture.get_size().x * mascot.scale.x - margin.x, margin.y)

#Focus dışarı çıktığında ekranın transparent öözelliğini geri getiriyorum. 
#Ancak focus ekrandayken niye çalışmadığın çözemedim.
func _notification(what):
	if what == MainLoop.NOTIFICATION_APPLICATION_FOCUS_IN:
		print("Window gained focus. Setting transparent = true.")
		get_window().transparent = true
	elif what == MainLoop.NOTIFICATION_APPLICATION_FOCUS_OUT:
		print("Window lost focus. Setting transparent = true.")
		get_window().transparent = true  
