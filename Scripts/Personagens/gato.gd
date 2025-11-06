extends CharacterBody2D

# Configurações de movimento
@export var distancia_minima: float = 200.0 # distância desejada do cavaleiro
@export var distancia_corrida: float = 250.0 # distância em que começa a correr
@export var velocidade: float = 180.0
@export var velocidade_correndo: float = 260.0
@export var gravidade: float = 900.0
@export var suavidade_movimento: float = 5.0

# Nós e variáveis de controle
@onready var cavaleiro: CharacterBody2D = get_parent().get_node_or_null("cavaleir_o")
@onready var animacao: AnimatedSprite2D = $AnimatedSprite2D
@onready var miado_triste: AudioStreamPlayer2D = $"miado triste"

var cavaleiro_morto: bool = false
var acordando: bool = true
var direcao: Vector2 = Vector2.ZERO

# --------------------
# Inicialização
# --------------------
func _ready() -> void:
	if cavaleiro and cavaleiro.has_signal("morreu"):
		cavaleiro.connect("morreu", Callable(self, "_ao_cavaleiro_morrer"))

	_tocar_animacao("Acordando")
	await animacao.animation_finished
	acordando = false

# --------------------
# Processamento físico
# --------------------
func _physics_process(delta: float) -> void:
	if acordando:
		move_and_slide()
		return

	if cavaleiro_morto:
		_tocar_animacao("Triste")
		if not miado_triste.playing:
			miado_triste.play()
		velocity = Vector2.ZERO
		move_and_slide()
		return

	if not cavaleiro:
		# tenta reencontrar o cavaleiro ao trocar de cena
		cavaleiro = get_tree().get_first_node_in_group("Cavaleiro")
		return

	# Aplica gravidade
	if not is_on_floor():
		velocity.y += gravidade * delta
	else:
		velocity.y = 0.0

	# Calcula direção e distância até o cavaleiro
	direcao = cavaleiro.global_position - global_position
	var distancia = direcao.length()

	# Impede o gato de subir/seguir verticalmente se o cavaleiro estiver em escada
	if "em_escada" in cavaleiro and cavaleiro.em_escada:
		direcao.y = 0

	# MOVIMENTO HORIZONTAL
	if distancia > distancia_corrida:
		velocity.x = lerp(velocity.x, direcao.normalized().x * velocidade_correndo, delta * suavidade_movimento)
		_tocar_animacao("Andando")
	elif distancia > distancia_minima:
		velocity.x = lerp(velocity.x, direcao.normalized().x * velocidade, delta * suavidade_movimento)
		_tocar_animacao("Andando")
	else:
		velocity.x = move_toward(velocity.x, 0, velocidade * delta * 3)
		if is_on_floor():
			_tocar_animacao("Parado")

	# ANIMAÇÕES DE PULO / QUEDA
	if not is_on_floor():
		if velocity.y < -50:
			_tocar_animacao("Pulando")
		elif velocity.y > 50:
			_tocar_animacao("Caindo")

	# Direção do sprite
	if velocity.x != 0:
		animacao.flip_h = velocity.x < 0

	move_and_slide()

# --------------------
# Reação à morte do cavaleiro
# --------------------
func _ao_cavaleiro_morrer() -> void:
	cavaleiro_morto = true
	velocity = Vector2.ZERO
	_tocar_animacao("Triste")
	miado_triste.play()

# --------------------
# Controle seguro de animações
# --------------------
func _tocar_animacao(nome: String) -> void:
	if animacao.animation != nome or not animacao.is_playing():
		animacao.play(nome)
