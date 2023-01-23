extends Control

var customerFile = "Customers.txt"
var customers = []
var currentCustomer = []
var rng = RandomNumberGenerator.new()


func _ready():
	rng.randomize()

func Init():
	$NextCustomer.disabled = true
	LoadCustomers()
	DisplayCustomer()

func HideCustomerMenu():
	visible = false
	mouse_filter = MOUSE_FILTER_IGNORE

func ShowCustomerMenu():
	rect_position = Vector2(0,0)
	visible = true
	mouse_filter = MOUSE_FILTER_STOP

func DisplayCustomer():
	#pick random customer and set as current customer
	var randomCustomer = customers[rng.randi_range(0, len(customers)-1)]
	currentCustomer = randomCustomer
	#$CustomerImage once I get assets I'll do this
	$CustomerMessage.text = currentCustomer[2]

func CheckCreation(sweet, sour, savory, caffiene):
	var customerWants = []
	customerWants = currentCustomer[1]
	var success = false

	if sweet >= customerWants[0] and sweet <= customerWants[1]:
		if sour >= customerWants[2] and sour <= customerWants[3]:
			if savory >= customerWants[4] and savory <= customerWants[5]:
				if caffiene >= customerWants[6] and caffiene <= customerWants[7]:
					success = true

	if success:
		$CustomerMessage.text = currentCustomer[3]
	else:
		$CustomerMessage.text = currentCustomer[4]

	$NextCustomer.disabled = false
	$BackButton.disabled = true

func LoadCustomers():
	var content = ReadLinesFromFile(customerFile)

	var numberOfCustomers = (len(content)) / 5	#each customer is 5 lines
	var index = 0

	for x in numberOfCustomers:
		var minsAndMaxes = content[index+1]
		minsAndMaxes = minsAndMaxes.split(",")
		var refinedNums = []
		for item in minsAndMaxes:
			refinedNums.append(int(item))
		var newCustomer = [content[index], refinedNums,content[index+2],content[index+3],content[index+4]]
		customers.append(newCustomer)

		index += 5





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


func _on_BackButton_pressed():
	HideCustomerMenu()
	get_owner().ShowMainScene()


func _on_NextCustomer_pressed():
	DisplayCustomer()
	$BackButton.disabled = false
	$NextCustomer.disabled = true
