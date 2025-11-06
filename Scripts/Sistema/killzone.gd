extends Area2D

@onready var som_morte: AudioStreamPlayer2D = $"som morte"

func _on_body_entered(body: Node2D) -> void:
	som_morte.play()
	await som_morte.finished
	body.morrer()
