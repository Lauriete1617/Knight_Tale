extends Node

#LISTA DE TODOS OS ITENS QUE EXISTEM
var catalogo_itens = [
	{"Nome": "Chá", "Icone": preload("res://Assets/Ícones/Chá - Ícone.png")},
	{"Nome": "Escudo", "Icone": preload("res://Assets/Ícones/Escudo - Ícone.png")},
	{"Nome": "Espada", "Icone": preload("res://Assets/Ícones/sword - Ícone.png")}
]

#LISTA DO INVENTÁRIO ATUAL E A QUANTIDADE DOS ITENS
var inventario_comum = {
	"Chá": 0
}
var inventario_armas = {
	"Espada": false,
	"Escudo": false
}

#ALTERAÇÕES NO INVENTÁRIO ATUAL
var item #item que vai ser alterado
func adicionar_item():
	print(item + " adicionado") #Não sei ainda como verificar o array
	
func adicionar_arma():
	print(item + " equipado(a)")
	
func remover_item():
	inventario_comum[item] -= 1
	if inventario_comum[item] == 0:
		inventario_comum[item].erase
