extends AnimatedSprite2D

# Mascotun animasyon durumlarını tanımlıyor.
enum States { IDLE_CAT, CAT_TO_MENU, MENU_TO_CAT, IDLE_MENU }
var current_state = States.IDLE_CAT
var button_height = 64
var button_count = 3
var body_part_height = 16  # Her bir parçanın pixel boyutu
var body_parts = []

#Referanslar
@onready var body_container = $BodyContainer
@onready var legs_sprite = $Legs
@onready var buttons = [$DropdownMenu/SaveButton, $DropdownMenu/FishingButton, $DropdownMenu/TaskButton]
@onready var dropdown_menu = $DropdownMenu

#Başlangıç fonksiyonu
func _ready():
	dropdown_menu.visible = false
	self.play("IdleCat")
	generate_body_parts()
	position_body_parts()  

#Menüyü açan fonksiyon
func toggle_menu():
	print("toggle_menu called")
	#Eğer menü kapalıysa açıyor
	if current_state == States.IDLE_CAT or current_state == States.MENU_TO_CAT:
		print("Playing CatToMenu")
		current_state = States.CAT_TO_MENU
		self.play("CattoMenu")
		show_body_parts(true)
		dropdown_menu.visible = true
	#Eğer menü açıksa kapatıyor ve durumu ona göre değiştiriyor.
	elif current_state == States.IDLE_MENU or current_state == States.CAT_TO_MENU:
		print("Playing MenutoCat")
		current_state = States.MENU_TO_CAT
		self.play("MenutoCat")
		show_body_parts(false)
		dropdown_menu.visible = false

#Menü butonu fonksiyonu
func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		toggle_menu()

#Menü Body'sinin renderlanması.
func show_body_parts(visible):
	for part in body_parts:
		part.visible = visible
	legs_sprite.visible = visible

#Animasyon bitiminde Idle state'e dönüş.
func _on_mascot_animation_finished():
	if current_state == States.CAT_TO_MENU:
		self.play("IdleMenu")
		current_state = States.IDLE_MENU
	elif current_state == States.MENU_TO_CAT:
		self.play("IdleCat")
		current_state = States.IDLE_CAT

#Menü Body'sinin buton sayısına göre gerekli boyutta yaratılması.
func generate_body_parts():
	# Sprite'ların sıfırlanması.
	for part in body_parts:
		part.queue_free()
	body_parts.clear()

	#Yeni Sprite Instancelarının yaratılması.
	var part_count = 2  
	for i in range(part_count):
		var part = Sprite2D.new()
		part.texture = preload("res://Sprite-0000.png")  #Atlas konumu.
		part.region_enabled = true
		part.region_rect = Rect2(504, 24, 16, 16)  #Sprite'ın atlastaki konumu
		part.position = Vector2(0, 0)  # Pozisyon ayarı
		part.visible = false
		body_container.add_child(part)
		body_parts.append(part)
	position_body_parts()

#Spriteların konumlandırılması
func position_body_parts():
	var start_y = 32  #Menü butonu ile hizalamak.
	for i in range(body_parts.size()):
		body_parts[i].position = Vector2(0, start_y + i * body_part_height)

	# Menünün alt kısmının hizalanması.
	legs_sprite.position = Vector2(0, start_y + body_parts.size() * body_part_height)
