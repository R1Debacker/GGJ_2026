extends Marker3D

@export var delay: float
@export var player_rank: int

var timer: Timer = Timer.new()

func _ready() -> void:
	# Configure the timer
	timer.wait_time = delay
	timer.one_shot = true
	timer.autostart = true

	# Connect the timeout signal
	timer.timeout.connect(_on_timer_timeout)

	# Add to scene so it runs
	add_child(timer)

func _on_timer_timeout() -> void:
	var ranked_player_datas = Game.get_rank_players_data()
	if ranked_player_datas.size() < player_rank+1:
		return
	var player_data = ranked_player_datas[player_rank]
	player3D_top_view.spawn(self, player_data)
