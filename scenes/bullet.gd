extends CharacterBody2D

func _process(_delta):
    move_and_slide()

func _on_area_2d_body_entered(body: Node2D):
    if body.has_method("take_damage"):
        body.take_damage()
        queue_free()
    else:
        queue_free()