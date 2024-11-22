extends CharacterBody3D

var is_reloading = false
var mag = 12
var mmag = 12
var hp = 10
var mhp = 10

var bullet_scene = load("res://bullet.tscn")

const SPEED = 8.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	# $Camera3D/HealthBar.get("theme_override_styles/fill").bg_color = Color.BLUE_VIOLET
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * 0.005)
		$Camera3D.rotate_x(-event.relative.y * 0.005)
		$Camera3D.rotation_degrees.x = clamp($Camera3D.rotation_degrees.x, -55,75)
		$ancher.rotate_x(-event.relative.y * 0.005)
		$ancher.rotation_degrees.x = clamp($Camera3D.rotation_degrees.x, -55,75)

func _physics_process(delta):
	if is_reloading:
		# 0 -> 100 in 3 seconds 
		$Camera3D/reloadprogress.value += (100/3) * delta
		if $Camera3D/reloadprogress.value >= 100:
			$Camera3D/reloadprogress.value = 100
			is_reloading = false
	if Input.is_action_just_pressed("reload") :
		$reloadt.start()
		is_reloading = true
		$Camera3D/reloadprogress.value = 0
	if Input.is_action_just_pressed("shoot") and mag > 0 and not is_reloading:
		mag -= 1
		$Camera3D/reloadprogress.value -= 8.33
		$Camera3D/mag.text = str(mag)
		var bullet = bullet_scene.instantiate()
		bullet.position = $Camera3D.global_position
		bullet.transform.basis = $Camera3D.global_transform.basis
		get_parent().add_child(bullet)
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if not $Walking.playing:
			$Walking.play()
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func _on_reloadt_timeout():
	mag = 12
	$Camera3D/reloadprogress.value = 100
	$Camera3D/mag.text = str(mag)
	
func hit(dmg):
	hp = hp - dmg
	print(hp)
	$Camera3D/hurt.visible = true
	$Camera3D/HealthBar.value = (hp / mhp) * 100
	if hp <= 0:
		get_tree().quit()
