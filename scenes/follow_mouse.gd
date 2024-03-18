extends Sprite2D
@export var camera: Camera2D

func _process(_delta):
    # follow the mouse
    global_position = get_global_mouse_position()