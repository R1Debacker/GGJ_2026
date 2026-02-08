extends ColorRect

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Game.fps_player.device_index == -1:
		visible = false
		return
	
	if not visible:
		visible = true
	
	var time_left = Game.fps_player.button_timer.time_left
	var wait_time = Game.fps_player.button_timer.wait_time
	
	scale.x = time_left / wait_time
