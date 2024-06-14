extends Node2D

signal task_finished #Task'in bittiğini gösteren sinyal

#Butonların referansları
@onready var start_button = $"start/Area2D"
@onready var pause_button = $"pause/Area2D"
@onready var reset_button = $"reset/Area2D"
@onready var timer_label = $"RichTextLabel"

#Değişken atamaları
var is_continue_mode = true
var timer = null
var remaining_time = 1500  # 25 dakika = 1500 saniye

#Başlangıç fonksiyonu
func _ready():
	start_button.input_event.connect(Callable(self, "_on_button_input").bind(start_button))
	pause_button.input_event.connect(Callable(self, "_on_button_input").bind(pause_button))
	reset_button.input_event.connect(Callable(self, "_on_button_input").bind(reset_button))
	update_timer_label()

#Butona basıldığında ilgili fonksiyonu çağıran fonsiyon
func _on_button_input(viewport, event, shape_idx, button):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if button == start_button:
			_on_start_button_pressed()
		elif button == pause_button:
			_on_pause_button_pressed()
		elif button == reset_button:
			_on_reset_button_pressed()

#start butonu fonksiyonu 
func _on_start_button_pressed():
	if not timer:
		timer = Timer.new()
		timer.wait_time = 1.0  # 1 saniyelik interval
		timer.connect("timeout", Callable(self, "_on_timer_timeout"))
		add_child(timer)
		timer.start()

#Durdurma butonu fonksiyonu
func _on_pause_button_pressed():
	if timer:
		timer.stop()
		timer.queue_free()
		timer = null

#Reset Butonu fonksiyonu
func _on_reset_button_pressed():
	if timer:
		timer.stop()
		timer.queue_free()
		timer = null
	remaining_time = 1500 if is_continue_mode else 300  # Reset to 25 minutes or 5 minutes
	update_timer_label()

#Süre bitince çağırılan fonksiyon
func _on_timer_timeout():
	remaining_time -= 1
	update_timer_label()
	if remaining_time <= 0:
		_on_time_up()

#Rest veya Continue moduna göre zaman sınırlamasını belirleyen fonksiyon
func _on_time_up():
	remaining_time = 300 if is_continue_mode else 1500  # Mod Switch
	is_continue_mode = not is_continue_mode
	update_timer_label()
	catch_fish()
	emit_signal("task_finished")  # Sayaç bitince task bitti sinyalini çağırır.

func catch_fish():
	#Consola balık yakaladım yazan fonksiyon
	print("Fish caught!")
	pass

#Sayacı güncelleyen fonksiyon
func update_timer_label():
	var minutes = int(remaining_time / 60)
	var seconds = int(remaining_time % 60)
	timer_label.text = pad_zeros(minutes, 2) + ":" + pad_zeros(seconds, 2)

#Sayaçtaki değerleri düzenleyen fonksiyon
func pad_zeros(value, length):
	var s = str(value)
	while s.length() < length:
		s = "0" + s
	return s
