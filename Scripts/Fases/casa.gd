extends Node2D

@onready var saida: Area2D = $Saída
@onready var armadura: Area2D = $"Itens/Suporte de armadura"
@onready var escudo: Area2D = $Itens/Escudo
@onready var som_saida: AudioStreamPlayer2D = $"som saida"

var pegou_escudo := false
var pegou_armadura := false

func _ready() -> void:
	# Oculta e desativa a saída
	saida.visible = false
	# Desativa temporariamente colisão da saída
	saida.set_collision_layer_value(5, false)
	saida.set_collision_mask_value(1, false)

	# Conecta os sinais
	escudo.body_entered.connect(_on_pegou_escudo)
	armadura.body_entered.connect(_on_pegou_armadura)

func _on_pegou_escudo(body: Node2D) -> void:
	pegou_escudo = true
	print("Escudo equipado!")
	verificar_itens()
	
func _on_pegou_armadura(body: Node2D) -> void:
	pegou_armadura = true
	print("Armadurado!")
	verificar_itens()
	
func verificar_itens() -> void:
	if pegou_escudo and pegou_armadura:
		print("Equipado e pronto pra aventura, pode sair!")
		saida.visible = true
		saida.set_collision_layer_value(5, true)
		saida.set_collision_mask_value(1, true)
		som_saida.play()
