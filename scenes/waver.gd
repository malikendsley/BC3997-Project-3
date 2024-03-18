extends AnimatedSprite2D

var orig: Vector2

var timer = 0.0

func _ready():
    orig = position

func _process(delta):
    # randomly modulate the sprite's position in a small range
    if timer <= 0:
        timer = 0.1
        position = orig + Vector2(randi_range( - 5, 5), randi_range( - 5, 5))
        modulate.a = randf()
    else:
        timer -= delta