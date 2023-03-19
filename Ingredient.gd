extends Sprite2D

var sweetValue = 0
var sourValue = 0
var savoryValue = 0
var caffieneValue = 0

var ingredientName = ""

signal AddIngredient(sweet, sour, savory, caffiene)


func Init(passedName, sweet, sour, savory, caffiene, xPos, yPos):
	#init values
	ingredientName = passedName
	sweetValue = sweet
	sourValue = sour
	savoryValue = savory
	caffieneValue = caffiene

	#set position of ingredient
	position.x = xPos
	position.y = yPos

	#display values
	$SweetIndicator.value = sweetValue
	$SourIndicator.value = sourValue
	$SavoryIndicator.value = savoryValue
	$CaffieneIndicator.value = caffieneValue

	$NameLabel.text = ingredientName

func _on_AddIngredient_pressed():
	emit_signal("AddIngredient", sweetValue, sourValue, savoryValue, caffieneValue)
