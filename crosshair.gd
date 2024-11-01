extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready():
	position = get_viewport_rect().get_center() - Vector2(5,5)

 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
