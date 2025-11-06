extends Area2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var som_vestir: AudioStreamPlayer2D = $"som vestir"

func _ready() -> void:
	animated_sprite.play("Com Armadura")
	
func _on_body_entered(body: Node2D) -> void:
	animated_sprite.play("Sem Armadura")
	if animated_sprite.animation_changed:
		som_vestir.play()
		await som_vestir.finished	
