extends Container

#Balıkları Yönetmek için sınıf yapısı
@export var fish_nodes = ["F1", "F2", "F3"]
@export var move_speed = 10  # Balıkların hareket hızı
@export var direction_change_interval = 0.5  # Balıkların yön değiştirme sıklığı
@export var disappear_interval = 300  # Balıkların kaybolma süresi
@export var reappear_interval = 300  # Balıkların geri gelme süresi
@export var idle_area_min = Vector2(0, 0)  # Idle bölgesinin minimum konumu
@export var idle_area_max = Vector2(144, 144)  # Idle bölgesinin maksimum konumu
var catched_fishes = 0
var is_continue_mode = true  # Oyun Continue modunda mı kontrol flag'ı
var fish_directions = {}

signal catched_fish_updated

#Başlangıç fonksiyonu
func _ready():
	set_process(true)
	if is_continue_mode:
		for fish_node_name in fish_nodes:
			var fish = get_node(fish_node_name)
			fish.call_deferred("start_disappear_cycle")
	for fish_node_name in fish_nodes:
		fish_directions[fish_node_name] = random_direction()
		get_tree().create_timer(direction_change_interval).timeout.connect(Callable(self, "change_directions"))

#Delta fonksiyonu tekrar eder.
func _process(delta):
	for fish_node_name in fish_nodes:
		var fish = get_node(fish_node_name)
		move_fish(fish, fish_directions[fish_node_name], delta)

#Mod atamasına göre balıkların davranışlarının ayarlanması.
func set_mode(mode: bool):
	is_continue_mode = mode
	for fish_node_name in fish_nodes:
		var fish = get_node(fish_node_name)
		if is_continue_mode:
			fish.start_disappear_cycle()
		else:
			fish.stop_disappear_cycle()
			fish.show()

#Balıkların hareket fonksiyonu
func move_fish(fish, direction, delta):
	fish.position += direction * move_speed * delta
	fish.position.x = clamp(fish.position.x, idle_area_min.x, idle_area_max.x)
	fish.position.y = clamp(fish.position.y, idle_area_min.y, idle_area_max.y)
	# Balık çok uzaklaşırse yönü tersine çevirmek.
	if fish.position.x == idle_area_min.x or fish.position.x == idle_area_max.x:
		fish_directions[fish.name] = Vector2(-direction.x, direction.y)
	if fish.position.y == idle_area_min.y or fish.position.y == idle_area_max.y:
		fish_directions[fish.name] = Vector2(direction.x, -direction.y)

#Balıkların yön değiştirme fonksiyonu
func change_directions():
	for fish_node_name in fish_nodes:
		fish_directions[fish_node_name] = random_direction()
	get_tree().create_timer(direction_change_interval).timeout.connect(Callable(self, "change_directions"))

func random_direction():
	# Balıklara rastgele yön ataması yapan fonksiyon
	if randf() > 0.2:  # 80% ihtimalle hareket edecekler.
		return Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	else:
		return Vector2.ZERO  # 20% ihtimalle duracaklar.

#Utility fonksiyonu.
func randf_range(min_val, max_val):
	return randf() * (max_val - min_val) + min_val

#Balıkların yakalanma fonksiyonu.
func catch_fish():
	for fish_node_name in fish_nodes:
		var fish = get_node(fish_node_name)
		if fish.visible:
			fish.visible = false
			catched_fishes = catched_fishes + 1
			break  # Aynı anda sadece 1 balık yakalayabiliriz

# Mod2a bağlı olarak balıkların geri gelme fonksiyonu.
func start_disappear_cycle(fish):
	var disappear_timer = Timer.new()
	disappear_timer.wait_time = disappear_interval
	disappear_timer.one_shot = true
	disappear_timer.timeout.connect(Callable(fish, "hide"))
	add_child(disappear_timer)
	disappear_timer.start()

	var reappear_timer = Timer.new()
	reappear_timer.wait_time = reappear_interval
	reappear_timer.one_shot = true
	reappear_timer.timeout.connect(Callable(fish, "show"))
	add_child(reappear_timer)
	reappear_timer.start()

#Balıkların kaybolmasını durduran fonksiyon.
func stop_disappear_cycle(fish):
	for child in fish.get_children():
		if child is Timer:
			child.stop()
