extends Node

var nb_buttons_active := 3
var buttons : Array[PushButton]

func on_button_pushed(button: PushButton):
	Game.fps_player.button_timer.stop()
	Game.fps_player.button_timer.start()
	set_active_buttons(button)

func clear_buttons():
	for button in buttons:
		if button.is_active:
			button.set_active_button(false);

func set_active_buttons(last_button: PushButton = null):
	var buttons_active : Array[PushButton]
	clear_buttons()
	for i in range(nb_buttons_active):
		var index = randi_range(0, buttons.size() - 1)
		while buttons[index] in buttons_active || buttons[index] == last_button:
			index = randi_range(0, buttons.size() - 1)
		buttons[index].set_active_button(true)
		buttons_active.append(buttons[index])
