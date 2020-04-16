extends Control

var party_size = 0 setget update_party_size

func _ready():
	$VBoxContainer/PartySelect/PartyAnts.text = "0/" + str(ColonyVariables.ants)

func update_party_size(change_to):
	WorldVariables.party["ants"] = change_to
	$VBoxContainer/PartySelect/PartyAnts.text = \
		str(WorldVariables.party["ants"]) + "/" + str(ColonyVariables.ants)

func update_party_size_request(amount):
	var target_size = WorldVariables.party["ants"] + amount
	if (target_size > 0) and (target_size <= ColonyVariables.ants):
		WorldVariables.party["ants"] += amount
		$VBoxContainer/PartySelect/PartyAnts.text = \
			str(WorldVariables.party["ants"]) + "/" + str(ColonyVariables.ants)

func _on_LessAnts_pressed():
	update_party_size_request(-1)

func _on_MoreAnts_pressed():
	update_party_size_request(1)
