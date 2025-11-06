extends Area2D

@onready var som_moeda: AudioStreamPlayer2D = $"som moeda"

func _on_body_entered(body: Node2D) -> void:
	print("+1 moeda")
	som_moeda.play()
	await som_moeda.finished
	queue_free()
