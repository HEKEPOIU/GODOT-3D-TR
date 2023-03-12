extends CharacterBody3D


@export var min_speed : float = 10
@export var max_speed : float = 18

signal squashed
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	move_and_slide()


func initialize(start_position, player_position):
	look_at_from_position(start_position,player_position,Vector3.UP) #生成時面相玩家
	rotate_y(randf_range(-PI/4,PI/4)) #稍微隨機一點旋轉數值，穰他不要完全向玩家走。
	
	var random_speed = randi_range(min_speed,max_speed)
	
	velocity = Vector3.FORWARD * random_speed  #向z-1方向走。然後乘以隨機移動速度
	
	velocity = velocity.rotated(Vector3.UP, rotation.y) #因為上面只計算了velocity的快慢，沒有決定朝向玩家，所以這裡要旋轉朝向玩家。
	$AnimationPlayer.speed_scale = random_speed / min_speed


func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()

func squash():
	squashed.emit()
	queue_free()
