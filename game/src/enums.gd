class_name Enums
extends Reference

enum Actor { ENVIRONMENT, PLAYER, ENEMY }

enum ActionType { ATTACK, MOVE, SCOUT, CONTROL }

enum CardSuperType { OFFICER, CREW, EVENT, VOID }

enum CardSubType { CAPTAIN, COMMANDER, SHIP, INSTANT, ONGOING, VOID }

enum ShipSuperType { SCOUT, CRUISER, CAPITAL_SHIP }

enum ShipSubType {
	CORVETTE,
	FRIGATE,
	DESTROYER,
	LIGHT_CRUISER,
	HEAVY_CRUISER,
	BATTLE_CRUISER,
	BATTLESHIP,
	DREADNOUGHT,
	CARRIER
}
