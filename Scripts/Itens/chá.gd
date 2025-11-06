extends Area2D

@onready var som: AudioStreamPlayer2D = $som

func _on_body_entered(body: Node2D) -> void:
	print("+1 chá")
	som.play()
	await som.finished
	queue_free()
