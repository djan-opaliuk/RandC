extends Sprite2D

#Balıkların Yakalandıklarında kaybolmalarını ve bir süre sonra yeniden ortaya çıkalarını sağlayan sınıf
var disappear_timer
var reappear_timer

#Sınıfın başlangıç fonksiyonu
func _ready():
	disappear_timer = Timer.new()
	reappear_timer = Timer.new()
	add_child(disappear_timer)
	add_child(reappear_timer)
	disappear_timer.wait_time = 300  # 5 minutes
	reappear_timer.wait_time = 300  # 5 minutes
	disappear_timer.one_shot = true
	reappear_timer.one_shot = true
	disappear_timer.timeout.connect(_on_disappear_timeout)
	reappear_timer.timeout.connect(_on_reappear_timeout)

#Balıkların tutulma döngüsünü başlatan fonksiyon
func start_disappear_cycle():
	disappear_timer.start()

#Balıkların kaybolma döngüsünü başlatan fonksiyon
func stop_disappear_cycle():
	if disappear_timer:
		disappear_timer.stop()
	if reappear_timer:
		reappear_timer.stop()
	show()

#Balıkları kaybeden fonksiyon
func _on_disappear_timeout():
	hide()
	reappear_timer.start()

#Balıkları geri getiren fonksiyon
func _on_reappear_timeout():
	show()
	disappear_timer.start()
