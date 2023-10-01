extends CanvasLayer
var rng = RandomNumberGenerator.new()

var width: int = 4;
var height: int = 4;
var chanceFor2: float = 0.9;

var gameGrid = [];

func make2dArray():
	var array = [];
	for i in width:
		array.append([]);
		for j in height:
			array[i].append(0);
	return array;

func placeRandom():
	var x = rng.randi_range(0, width-1)
	var y = rng.randi_range(0, height-1)
	for i in width:
		for j in height:
			var a = (i + x) % width
			var b = (j + y) % width
			if gameGrid[a][b] == 0:
				gameGrid[a][b] = 2
				if rng.randf() > chanceFor2:
					gameGrid[a][b] *= 2
				return
	print("all full")
	return

func printArray():
	var index = 0
	var x = 0
	var score = 0
	print("------------")
	for i in gameGrid:
		print(i)
		var y = 0
		for j in i:
			var element = $GridContainer.get_child(index)
			var texture = element.get_node("TextureRect")
			var resource
			if j != 0:
				if j < 0:
					element.get_node("GPUParticles2D").restart()
					j *= -1
					gameGrid[x][y] = j
				score += j
				resource = load("res://Textures/" + String.num(j) + ".png")
				texture.texture = resource
			else:
				texture.texture = null
			#element.get_node("Label").text = String.num(j)
			index += 1
			y += 1
		x += 1
		$Label.text = "Score: " + String.num(score)

func handle(workspace):
	compress(workspace)
	compress(workspace)
	combine(workspace)
	compress(workspace)
	compress(workspace)
	return workspace

func compress(workspace):
	var length = workspace.size() - 1
	for i in length:
		if workspace[i] != 0:
			if workspace[i + 1] == 0:
				workspace[i + 1] = workspace[i]
				workspace[i] = 0
	return workspace

func combine(workspace):
	var length = workspace.size() - 1
	for j in length:
		var i = length - 1 - j
		if workspace[i] != 0:
			if workspace[i + 1] == workspace[i]:
				workspace[i + 1] *= - 2
				workspace[i] = 0
	return workspace

func moveDown():
	print("move down")
	var workspace = [0,0,0,0]
	for i in width:
		for j in height:
			workspace[j] = gameGrid[j][i]
		workspace = handle(workspace)
		for j in height:
			gameGrid[j][i] = workspace[j]
	nextTurn()

func moveUp():
	print("move up")
	var workspace = [0,0,0,0]
	for i in width:
		for j in height:
			workspace[height - 1 - j] = gameGrid[j][i]
		workspace = handle(workspace)
		for j in height:
			gameGrid[j][i] = workspace[height - 1 - j]
	nextTurn()

func moveLeft():
	print("move left")
	var workspace = [0,0,0,0]
	for j in height:
		for i in width:
			workspace[width - 1 - i] = gameGrid[j][i]
		workspace = handle(workspace)
		for i in width:
			gameGrid[j][i] = workspace[width - 1 - i]
	nextTurn()
	
func moveRight():
	print("move right")
	var workspace = [0,0,0,0]
	for j in height:
		for i in width:
			workspace[i] = gameGrid[j][i]
		workspace = handle(workspace)
		for i in width:
			gameGrid[j][i] = workspace[i]
	nextTurn()

func nextTurn():
	placeRandom()
	printArray()

# Called when the node enters the scene tree for the first time.
func _ready():
	gameGrid = make2dArray();
	placeRandom()
	placeRandom()
	printArray()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("Down"):
		moveDown()
	if Input.is_action_just_pressed("Up"):
		moveUp()
	if Input.is_action_just_pressed("Left"):
		moveLeft()
	if Input.is_action_just_pressed("Right"):
		moveRight()
