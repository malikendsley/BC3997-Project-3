extends Sprite2D

var timer = 0.0

func _process(delta):
    if timer <= 0:
        timer = 0.1
        frame = 1 if randi() % 2 == 0 else 0
    else:
        timer -= delta