extends Node

var maxLevel: int = 1
var maxCombo: int = 0
var QueenspeedFactor: float = 2

func increaseSpeedFactor():
	maxLevel = maxLevel + 1
	QueenspeedFactor = QueenspeedFactor * 2
	print(QueenspeedFactor)

func resetQueenSpeedFactor():
	QueenspeedFactor = 2
	maxLevel = 1
