extends CharacterBody2D

signal morreu

const VELOCIDADE = 120.0
const PULO_VELOCIDADE = -400.0
const VELOCIDADE_ESCADA = 120.0
const GRAVIDADE = 1000.0
const ALTURA_DEGRAU = 24.0 # altura menor pra suavizar o movimento (bloco = 32px)

@onready var animacao: AnimatedSprite2D = $AnimatedSprite2D
@onready var som_pulo: AudioStreamPlayer2D = $"Sons/som pulo"
@onready var som_degrau: AudioStreamPlayer2D = $"Sons/som degrau" # <--- adicione esse nó na cena!

var direcao: float = 0.0
var pousando: bool = false
var estava_no_chao: bool = false
var em_escada: bool = false
var atacando: bool = false
var comemorando: bool = false
var morto: bool = false
var subindo_degrau: bool = false

func _ready() -> void:
	add_to_group("Cavaleiro")

func _physics_process(delta: float) -> void:
	if morto:
		return

	if comemorando:
		velocity = Vector2.ZERO
		_tocar_animacao("Comemorando - sem espada")
		move_and_slide()
		return

	if atacando:
		mover_normal(delta)
		move_and_slide()
		atualizar_animacao()
		return

	if em_escada:
		mover_na_escada(delta)
		move_and_slide()
		atualizar_animacao()
		return

	mover_normal(delta)
	move_and_slide()
	atualizar_animacao()

# ----------------------------
# MOVIMENTO NORMAL (CHÃO/AR)
# ----------------------------
func mover_normal(delta: float) -> void:
	# Gravidade
	if not is_on_floor():
		velocity.y += GRAVIDADE * delta
	else:
		velocity.y = 0

	direcao = Input.get_axis("Esquerda", "Direita")
	subindo_degrau = false

	if direcao != 0 and not em_escada:
		# Tenta mover normalmente
		var tentativa = Vector2(direcao * VELOCIDADE * delta, 0)
		var col = move_and_collide(tentativa)

		# Se colidir horizontalmente, tenta subir o degrau suavemente
		if col:
			for i in range(2): # duas tentativas suaves de subida (em 2 metades)
				var passo = Vector2(0, -ALTURA_DEGRAU / 2)
				col = move_and_collide(passo)
				if not col:
					var lateral = Vector2(direcao * VELOCIDADE * delta, 0)
					col = move_and_collide(lateral)
					if not col:
						subindo_degrau = true
						if not som_degrau.playing:
							som_degrau.play()
						break
	else:
		velocity.x = move_toward(velocity.x, 0, VELOCIDADE)

	# Atualiza velocidade lateral
	if direcao != 0:
		velocity.x = direcao * VELOCIDADE

	# Pulo normal
	if Input.is_action_just_pressed("Pular") and is_on_floor():
		velocity.y = PULO_VELOCIDADE
		som_pulo.play()

	# Pouso
	if is_on_floor() and not estava_no_chao:
		iniciar_animacao_pouso()

	estava_no_chao = is_on_floor()

# ----------------------------
# MOVIMENTO NA ESCADA (de mão)
# ----------------------------
func mover_na_escada(delta: float) -> void:
	velocity = Vector2.ZERO
	var vertical = Input.get_axis("Cima", "Baixo")
	var horizontal = Input.get_axis("Esquerda", "Direita")
	velocity.y = vertical * VELOCIDADE_ESCADA
	velocity.x = horizontal * VELOCIDADE * 0.5

# ----------------------------
# ATUALIZAÇÃO DE ANIMAÇÕES
# ----------------------------
func atualizar_animacao() -> void:
	if comemorando:
		_tocar_animacao("Comemorando - sem espada")
		return

	if atacando:
		_tocar_animacao("Ataque leve pra baixo")
		return

	if em_escada:
		if abs(velocity.y) > 0 or abs(velocity.x) > 0:
			_tocar_animacao("Escada - sem espada")
		else:
			_tocar_animacao("Escada parada - sem espada")
		return

	if subindo_degrau:
		_tocar_animacao("Pulando - com espada")
		return

	if not is_on_floor():
		if velocity.y < 0:
			_tocar_animacao("Pulando - com espada")
		elif velocity.y > 0:
			_tocar_animacao("Caindo - sem espada")
		return

	if abs(velocity.x) > 0.1:
		_tocar_animacao("Andando - sem espada")
		animacao.flip_h = velocity.x < 0
		return

	_tocar_animacao("Parado - sem espada")

# ----------------------------
# FUNÇÕES AUXILIARES
# ----------------------------
func iniciar_animacao_pouso() -> void:
	if pousando:
		return
	pousando = true
	await get_tree().process_frame
	await animacao.animation_finished
	pousando = false

func realizar_ataque() -> void:
	if atacando:
		return
	atacando = true
	_tocar_animacao("Ataque leve pra baixo")
	await animacao.animation_finished
	atacando = false

func morrer():
	if morto:
		return
	morto = true
	_tocar_animacao("Morrendo - sem espada")
	await animacao.animation_finished
	print("Você morreu!")
	emit_signal("morreu")
	await get_tree().create_timer(2.0).timeout
	get_tree().reload_current_scene()

func festa():
	comemorando = true
	velocity = Vector2.ZERO
	_tocar_animacao("Comemorando - sem espada")

# ----------------------------
# CONTROLE DE ESCADA (de mão)
# ----------------------------
func entrar_escada():
	em_escada = true
	velocity = Vector2.ZERO
	_tocar_animacao("Escada parada - sem espada")

func sair_escada():
	em_escada = false
	_tocar_animacao("Parado - sem espada")

func _tocar_animacao(nome: String) -> void:
	if animacao.animation != nome or not animacao.is_playing():
		animacao.play(nome)
