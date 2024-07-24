extends Node

var inventory = []

func add_item(item):
	inventory.append(item)
	print(inventory)

func use_item(item):
	print(inventory)
	return inventory.has(item)
