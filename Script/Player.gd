extends CharacterBody3D


@export var speed : int = 14
@export var fall_acceleration : int = 75  #掉下來的加速度，距離以meter/s為單位
@export var jump_impulse = 20
@export var bounce_impulse = 16

signal hit

var target_velocity : Vector3 = Vector3.ZERO

var direction: Vector3 = Vector3.ZERO

func _physics_process(delta: float) -> void:  #就像是unity的fixedupdate
	if Input.is_action_pressed("move_right"): #注意godot上下是y軸。
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
		
	if direction != Vector3.ZERO:
		direction =direction.normalized() #主要是我們是要方向，上面如果同時按下兩個w a他會超過1 這代表斜著走會比較快，但這裡不需要這種無用得設計。
		$pivot.look_at(position+direction,Vector3.UP)
		$AnimationPlayer.speed_scale = 4
	else :
		$AnimationPlayer.speed_scale = 1
		
	target_velocity.x = direction.x * speed * delta
	target_velocity.z = direction.z * speed * delta
	
#	if not is_on_floor(): #這是如果物體沒有在地板上，他就施加一個向下的力量，簡單來說是重力，當然你也可以直接讓Y永遠保有向下的速度，但這樣應該比較節能。
		#目前看起來判斷floor的方式是角度
	target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse
	velocity = target_velocity
	move_and_slide()  #這東西是如果物體有velocity(速度)的時候，他就會移動，基於物理的，所以這引擎的物理也要手打出來。
	velocity = get_real_velocity()
	
#	for index in range(get_slide_collision_count()): #獲取所有碰撞的東西，就算mask沒有勾他
#		var collision := get_slide_collision(index) 
##		if (collision.get_collider() == null): 
#		#get_collider 獲取碰撞的物體，阿如果沒有就跳過，但在這裡這串話是廢話，如果沒有碰撞怎摩會進來這迴圈，官方在搞誒
##			continue
#
#		if collision.get_collider().is_in_group("mob"):
#			var mob:= collision.get_collider()
#			if Vector3.UP.dot(collision.get_normal()) > 0.5: #Ａ，Ｂ點乘可以知道大概夾角為幾度（返回數值在－１　１間（１８０－０），　阿我要上面，所以要大於.5
#				mob.squash()
#				target_velocity.y = bounce_impulse
		
	$pivot.rotation.x = PI / 6 * velocity.y / jump_impulse  #跳起來後稍微轉一點角度　會讓他看起來比較像是下墜
	direction = Vector3.ZERO

func die() -> void:
	hit.emit()
	queue_free()

func _on_mob_detector_body_entered(body: Node3D) -> void:
	die()


func _on_footpoint_body_entered(body: Node3D) -> void:
	body.squash()
	target_velocity.y = bounce_impulse
