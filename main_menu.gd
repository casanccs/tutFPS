extends Control

var world1 = preload("res://world.tscn").instantiate()
var world2 = preload("res://world_2.tscn").instantiate()
var world3 = preload("res://world_3.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

 
func _on_world_1_pressed():
	queue_free()
	get_tree().root.add_child(world1)


func _on_world_2_pressed():
	queue_free()
	get_tree().root.add_child(world2)
 


func _on_world_3_pressed():
	queue_free()
	get_tree().root.add_child(world3)
