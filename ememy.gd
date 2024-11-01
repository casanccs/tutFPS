extends CharacterBody3D

@onready var nav = $NavigationAgent3D
@onready var player = $"/root/World 2/player"

const SPEED = 1.5
const JUMP_VELOCITY = 4.5
var hp = 3
var toHit = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	var direction = Vector3()
	nav.target_position = player.global_position
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	direction *= SPEED
	velocity = direction
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if toHit:
		move_and_slide()
	
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
		if collision.get_collider().is_in_group('player') and toHit:
			collision.get_collider().hit(5)
			toHit = false
			$Timer.start()
	
func hit(dmg):
	hp = hp - dmg
	if hp <= 0:
		queue_free()
	


func _on_timer_timeout():
	toHit = true


func _on_sound_timer_timeout():
	$Sound.play()
	$SoundTimer.wait_time = randi_range(3,10)
