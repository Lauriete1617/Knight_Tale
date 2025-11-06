extends Area2D

@onready var som_vencer: AudioStreamPlayer2D = $"som vencer"
@onready var timer: Timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	print("Parabéns!")
	body.festa()
	som_vencer.play()
	timer.start()

func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://Scenes/Fases/fase_1_(tutorial).tscn")
