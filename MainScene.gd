extends Control

var ingredient = preload("res://Ingredient.tscn")

var sweetValue = 0
var sourValue = 0
var savoryValue = 0
var caffieneValue = 0

func _ready():

	$SweetIndicator.value = sweetValue
	$SourIndicator.value = sourValue
	$SavoryIndicator.value = savoryValue
	$CaffieneIndicator.value = caffieneValue


	var newIngredient = ingredient.instance()
	#passedName, sweet, sour, savory, caffiene, xPos, yPos
	newIngredient.Init("apple", 1, 4, 3, 0, 100, 100)
	newIngredient.connect("AddIngredient", self, "HandleAddIngredient")
	add_child(newIngredient)





func HandleAddIngredient(sweet, sour, savory, caffiene):

	sweetValue = sweet
	sourValue = sour
	savoryValue = savory
	caffieneValue = caffiene

	$SweetIndicator.value = sweetValue
	$SourIndicator.value = sourValue
	$SavoryIndicator.value = savoryValue
	$CaffieneIndicator.value = caffieneValue




