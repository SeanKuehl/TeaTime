extends Control

var ingredientObject = preload("res://Ingredient.tscn")
var ingredientsFile = "Ingredients.txt"

var sweetValue = 0
var sourValue = 0
var savoryValue = 0
var caffieneValue = 0

var milkAdded = false
var creamAdded = false

var ingredientGridStartX = 110
var ingredientGridStartY = 50
var ingredientIndex = 0

func _ready():

	$SweetIndicator.value = sweetValue
	$SourIndicator.value = sourValue
	$SavoryIndicator.value = savoryValue
	$CaffieneIndicator.value = caffieneValue

	var ingredients = LoadIngredientsFromFile()

	for ingredient in ingredients:
		if ingredientIndex == 5:
			ingredientGridStartX = 110
			ingredientGridStartY += 150

		var newIngredient = ingredientObject.instance()
		newIngredient.Init(ingredient[0], ingredient[1], ingredient[2], ingredient[3], ingredient[4], ingredientGridStartX, ingredientGridStartY)
		newIngredient.connect("AddIngredient", self, "HandleAddIngredient")
		add_child(newIngredient)
		ingredientGridStartX += 200
		ingredientIndex += 1
	#passedName, sweet, sour, savory, caffiene, xPos, yPos




func LoadIngredientsFromFile():
	var data = ReadLinesFromFile(ingredientsFile)
	var ingredients = []
	for x in data:
		var seperatedVals = x.split(",")
		var convertedVals = [seperatedVals[0], int(seperatedVals[1]), int(seperatedVals[2]), int(seperatedVals[3]), int(seperatedVals[4])]
		ingredients.append(convertedVals)


	return ingredients

func HandleAddIngredient(sweet, sour, savory, caffiene):

	sweetValue = sweet
	sourValue = sour
	savoryValue = savory
	caffieneValue = caffiene

	$SweetIndicator.value = sweetValue
	$SourIndicator.value = sourValue
	$SavoryIndicator.value = savoryValue
	$CaffieneIndicator.value = caffieneValue


func ReadLinesFromFile(fileName):
	var file = File.new()
	file.open(fileName, File.READ)
	var content = []
	#check for empty lines! reading etc the file will add an empty line onto the end of it
	var line = ""
	while file.eof_reached() == false:
		line = file.get_line()
		if line == "":
			#it's an empty line, ignore it
			pass
		else:
			content.append(line)

	file.close()

	return content


func UpdateValues():
	#check to see if any value is above max
	$SweetIndicator.value = sweetValue
	$SourIndicator.value = sourValue
	$SavoryIndicator.value = savoryValue
	$CaffieneIndicator.value = caffieneValue

func _on_AddCream_pressed():
	#if milk was also selected, deselect it
	if milkAdded == true:
		#you can't have both milk and cream!

		#undo it's effects
		savoryValue -= 1
		#update values
		UpdateValues()

		#deselect it on the menu and in code
		milkAdded = false
		$AddMilk.pressed = false


	if creamAdded == false:
		creamAdded = true
		sweetValue += 1
		savoryValue += 1
		#update values
		UpdateValues()
	elif creamAdded == true:
		creamAdded = false
		sweetValue -= 1
		savoryValue -= 1
		UpdateValues()



func _on_AddMilk_pressed():
	#if cream was also selected, deselect it
	if creamAdded == true:
		#you can't have both milk and cream!

		#undo it's effects
		sweetValue -= 1
		savoryValue -= 1
		#update values
		UpdateValues()

		#deselect it on the menu and in code
		creamAdded = false
		$AddCream.pressed = false

	if milkAdded == false:
		milkAdded = true
		savoryValue += 1
		#update values
		UpdateValues()
	elif milkAdded == true:
		milkAdded = false
		savoryValue -= 1
		UpdateValues()






func _on_SugarsSlider_value_changed(value):
	#0,1 or 2
	pass # Replace with function body.


func _on_SteepTimeSlider_value_changed(value):
	pass # Replace with function body.
