class_name PushButton
extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var is_active := false

func _ready() -> void:
	set_active_button(false)
	ButtonManager.buttons.append(self)
	
func set_active_button(active: bool):
	is_active = active
	if active:
		animation_player.play("active")
	else:
		animation_player.play("inactive")
	


func _on_area_3d_body_entered(body: Node3D) -> void:
	if is_active && body is FpsPlayer:
		ButtonManager.on_button_pushed(self)
