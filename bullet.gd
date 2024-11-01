extends CharacterBody3D

var dmg = 1

func _process(delta):
	velocity = transform.basis*Vector3(0,0,-75)
	var collision = move_and_collide(velocity*delta)
	
	if collision:
		velocity = Vector3.ZERO
		
		if collision.get_collider().is_in_group('enemy'):
			collision.get_collider().hit(dmg)
			queue_free()


func _on_timer_timeout():
	queue_free()
