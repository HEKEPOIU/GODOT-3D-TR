extends Node

@export var mob_scene : PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()  #隨機其他隨機碼的順序，不做的話每次生成位置都會依樣。
	$UserInterface/Retry.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mob_timer_timeout() -> void:
	var mob : Node = mob_scene.instantiate()
	
	var mob_spawn_location : Node = get_node("SpawnPath/PathLocation")
	
	mob_spawn_location.progress_ratio = randf()
	var player_position = $Player.position
	mob.initialize(mob_spawn_location.position, player_position)
	mob.squashed.connect($UserInterface/ScoreLabel._on_Mob_squashed.bind())
	add_child(mob)


func _on_player_hit() -> void:
	$MobTimer.stop()
	$UserInterface/Retry.show()
	
func _unhandled_input(event) -> void:  #只要按了inputmap的東西就會觸發這個
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		get_tree().reload_current_scene()	
