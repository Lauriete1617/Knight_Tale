extends Area2D

@onready var som_equipar: AudioStreamPlayer2D = $"som equipar"

func _on_body_entered(body: Node2D) -> void:
	print("Escudo equipado!")
	som_equipar.play()
	await som_equipar.finished
	queue_free()
