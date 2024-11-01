extends CharacterBody3D

func _ready():
	position.y = randf_range(1,7)
	position.x = randf_range(-5,5)
	position.z = -10

func _on_timer_timeout():
	position.y = randf_range(1,7)
	position.x = randf_range(-5,5)
