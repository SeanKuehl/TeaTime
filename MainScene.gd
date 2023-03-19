extends Control

var ingredientObject = preload("res://Ingredient.tscn")
var ingredientsFile = "Ingredients.txt"

var sweetValue = 0
var sourValue = 0
var savoryValue = 0
var caffieneValue = 0

var milkAdded = false
var creamAdded = false

var lastSugarValue = 0
var lastSteepValue = 2

var ingredientList = []
var ingredientObjectList = []


var numberOfIngredients = 0
var maxIngredients = 5



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

		var newIngredient = ingredientObject.instantiate()
		newIngredient.Init(ingredient[0], ingredient[1], ingredient[2], ingredient[3], ingredient[4], ingredientGridStartX, ingredientGridStartY)
		newIngredient.connect("AddIngredient",Callable(self,"HandleAddIngredient"))
		add_child(newIngredient)
		ingredientObjectList.append(newIngredient)
		ingredientGridStartX += 200
		ingredientIndex += 1
	#passedName, sweet, sour, savory, caffiene, xPos, yPos
	HideMainScene()
	$CustomerMenu.Init()
	$CustomerMenu.ShowCustomerMenu()


func _process(_delta):
	$TeaCupSweetAmount.text = str(sweetValue)+"/"+str($SweetIndicator.max_value)
	$TeaCupSourAmount.text = str(sourValue)+"/"+str($SourIndicator.max_value)
	$TeaCupSavoryAmount.text = str(savoryValue)+"/"+str($SavoryIndicator.max_value)
	$TeaCupCaffieneAmount.text = str(caffieneValue) +"/"+str($CaffieneIndicator.max_value)

func HideMainScene():


	$TeaCupSweetAmount.hide()
	$TeaCupSourAmount.hide()
	$TeaCupSavoryAmount.hide()
	$TeaCupCaffieneAmount.hide()
	#hide Ingredients
	for x in ingredientObjectList:
		x.hide()

	mouse_filter = MOUSE_FILTER_IGNORE

func ShowMainScene():

	$TeaCupSweetAmount.show()
	$TeaCupSourAmount.show()
	$TeaCupSavoryAmount.show()
	$TeaCupCaffieneAmount.show()
	#hide Ingredients
	for x in ingredientObjectList:
		x.show()

	mouse_filter = MOUSE_FILTER_STOP


func LoadIngredientsFromFile():
	var data = ReadLinesFromFile(ingredientsFile)
	var ingredients = []
	for x in data:
		var seperatedVals = x.split(",")
		var convertedVals = [seperatedVals[0], int(seperatedVals[1]), int(seperatedVals[2]), int(seperatedVals[3]), int(seperatedVals[4])]
		ingredients.append(convertedVals)


	return ingredients

func HandleAddIngredient(sweet, sour, savory, caffiene):

	if numberOfIngredients < maxIngredients:
		numberOfIngredients += 1
		UpdateNumberOfIngredientsLabel()


		ingredientList.append([sweet, sour, savory, caffiene])

		sweetValue += sweet
		sourValue += sour
		savoryValue += savory
		caffieneValue += caffiene
		UpdateValues()

		if numberOfIngredients == maxIngredients:
			$PresentButton.text = "Present"


func ReadLinesFromFile(fileName):
	var file = FileAccess.open(fileName, FileAccess.READ)
	
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

func UpdateNumberOfIngredientsLabel():
	$NumberOfIngredients.text = "Ingredients: " +str(numberOfIngredients)+"/" +str(maxIngredients)

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
		$AddMilk.button_pressed = false


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
		$AddCream.button_pressed = false

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
	#given that it starts at 0
	sweetValue -= lastSugarValue
	sweetValue += value
	UpdateValues()
	lastSugarValue = value


func _on_SteepTimeSlider_value_changed(value):
	#2,3,4 or 5
	if lastSteepValue == 2:
		#no values to undo
		pass
	if lastSteepValue == 3:
		sweetValue -= 1
		sourValue -= 1
		savoryValue -= 1
		caffieneValue -= 1
		UpdateValues()
	if lastSteepValue == 4:
		sweetValue -= 2
		sourValue -= 2
		savoryValue -= 2
		caffieneValue -= 2
		UpdateValues()
	if lastSteepValue == 5:
		sweetValue -= 3
		sourValue -= 3
		savoryValue -= 3
		caffieneValue -= 3
		UpdateValues()


	if value == 3:
		sweetValue += 1
		sourValue += 1
		savoryValue += 1
		caffieneValue += 1
		UpdateValues()
	if value == 4:
		sweetValue += 2
		sourValue += 2
		savoryValue += 2
		caffieneValue += 2
		UpdateValues()
	if value == 5:
		sweetValue += 3
		sourValue += 3
		savoryValue += 3
		caffieneValue += 3
		UpdateValues()

	lastSteepValue = value


func _on_RemoveLastIngredient_pressed():
	var removalList = []

	if (len(ingredientList)) > 0:
		removalList = ingredientList[-1]
		sweetValue -= removalList[0]
		sourValue -= removalList[1]
		savoryValue -= removalList[2]
		caffieneValue -= removalList[3]
		UpdateValues()
		ingredientList.pop_back()
		numberOfIngredients -= 1
		UpdateNumberOfIngredientsLabel()

		if $PresentButton.text == "Present":
			$PresentButton.text = "View Customer"


func ResetForNextCustomer():
	sweetValue = 0
	sourValue = 0
	savoryValue = 0
	caffieneValue = 0
	$SugarsSlider.value = 0
	$AddMilk.button_pressed = false
	$AddCream.button_pressed = false
	$SteepTimeSlider.value = 0
	UpdateValues()
	numberOfIngredients = 0
	UpdateNumberOfIngredientsLabel()
	ingredientList = []



func _on_PresentButton_pressed():
	if numberOfIngredients == maxIngredients:
		HideMainScene()
		$CustomerMenu.CheckCreation(sweetValue, sourValue, savoryValue, caffieneValue)
		ResetForNextCustomer()
		$CustomerMenu.ShowCustomerMenu()
	else:
		HideMainScene()
		$CustomerMenu.ShowCustomerMenu()
