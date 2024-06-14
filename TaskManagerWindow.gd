extends Control

@onready var buttons = [
	$"ButtonTask", 
	$"ButtonTask2", 
	$"ButtonTask3", 
	$"ButtonTask4"
]
@onready var labels = [
	$"Control2/RichTextLabel", 
	$"Control2/RichTextLabel2", 
	$"Control2/RichTextLabel3", 
	$"Control2/RichTextLabel4"
]

@onready var draggable = self.get_parent() # Draggable node'u ekleyelim

func _ready():
	# Initially hide all buttons except the first one
	for i in range(buttons.size()):
		buttons[i].visible = i == 0
		labels[i].visible = i == 0
		labels[i].text = "+"
	
	# Connect signals for all buttons
	for i in range(buttons.size()):
		var area = buttons[i].get_node("Area2D")
		if area:
			area.connect("input_event", Callable(self, "_on_ButtonTask_pressed").bind(i))
		else:
			print("Area2D not found in button ", i)

func _on_ButtonTask_pressed(viewport, event, shape_idx, index):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("Task Button Pressed: ", index)
		if index < buttons.size() - 1:
			buttons[index + 1].visible = true
			labels[index + 1].visible = true

		# Get text input from the user
		draggable.dragging = false # Dialog açıldığında drag'i devre dışı bırak
		var text = await get_text_input_dialog("Enter Task")
		draggable.dragging = true # Dialog kapandığında drag'i tekrar etkinleştir
		labels[index].text = text if text != "" else "+"
		
		# Hide the next button if no text is entered
		if text == "":
			if index < buttons.size() - 1:
				buttons[index + 1].visible = false
				labels[index + 1].visible = false

func get_text_input_dialog(title) -> String:
	var dialog = AcceptDialog.new()
	dialog.dialog_text = title
	var line_edit = LineEdit.new()
	dialog.add_child(line_edit)
	dialog.add_button("OK", true)
	add_child(dialog)
	dialog.popup_centered()

	await dialog.confirmed

	var text = line_edit.text
	dialog.queue_free()
	return text
