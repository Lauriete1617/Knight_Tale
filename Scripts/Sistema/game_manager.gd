extends Node

# VARIÁVEIS
var coin = 0
var score = 0
var mortes = 0
var inimigos = 0

# GERENCIAR PONTUAÇÃO GERAL
#CONTAR MOEDAS
func add_coin():
	coin =+ 1
	score =+ 10
	print("Moedas: " + coin)

#CONTAR MORTES DO PLAYER
func add_death():
	mortes =+ 1
	score =- 50
	print("Você morreu " + mortes + " vezes...Tente novamente!")
	
#CONTAR INIMIGOS DERROTADOS
func add_enemy():
	inimigos =+ 1
	score =+ 100
	print("Inimigos derrotados: " + inimigos)

# RESETA AS ESTATÍSTICAS DA FASE COMPLETAMENTE
func reset_stats():
	coin = 0
	score = 0
	mortes = 0
	inimigos = 0
	print("Estatísticas resetadas")
