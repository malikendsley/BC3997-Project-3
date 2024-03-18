extends Area2D

@export var fader: ColorRect
@export var control: Control
@export var purp: ColorRect
@export var text: Label
func _on_body_entered(body: Node2D):
    if body is Player:
        print("Fading")
        control.modulate.a = 1
        purp.modulate.a = 0
        text.modulate.a = 0
        var tween = get_tree().create_tween()
        tween.tween_property(fader, "modulate:a", 1, 5)
