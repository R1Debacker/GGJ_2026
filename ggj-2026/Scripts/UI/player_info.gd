extends Control

@export var device_idx: int
var score : float = 0
var rob_count = 0

@onready var txt_score: RichTextLabel = $Control/CenterContainer/VBoxContainer/HSplitContainer2/TxtScore2
@onready var txt_device_index: RichTextLabel = $Control/CenterContainer/VBoxContainer/HSplitContainer/TxtDeviceIndex2
@onready var txt_rob_count: RichTextLabel = $Control/CenterContainer/VBoxContainer/HSplitContainer3/TxtRobCount2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	txt_device_index.clear()
	txt_device_index.add_text(str(device_idx))
	txt_rob_count.clear()
	txt_rob_count.add_text(str(rob_count))
	txt_score.clear()
	txt_score.add_text(str(score))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Game.fps_player.device_index != device_idx:
		return
	score += 1000 * delta
	txt_score.clear()
	txt_score.add_text(str(score))
