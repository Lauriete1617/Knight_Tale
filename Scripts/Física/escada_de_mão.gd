extends Area2D

func _on_body_entered(body: Node2D) -> void:
	body.em_escada = true

	# Desativa colisões enquanto sobe/desce
	body.set_collision_layer_value(1, false)
	body.set_collision_mask_value(5, false)
	body.set_collision_mask_value(1, false)

	# Chama função do personagem, se existir
	if body.has_method("entrar_escada"):
		body.entrar_escada()


func _on_body_exited(body: Node2D) -> void:
	body.em_escada = false

	# Reativa colisões ao sair
	body.set_collision_layer_value(1, true)
	body.set_collision_mask_value(5, true)
	body.set_collision_mask_value(1, true)

	# Chama função do personagem, se existir
	if body.has_method("sair_escada"):
		body.sair_escada()
