extends LootTable

func _init() -> void:
	ID="loot_museum"
	tier=1
	table=[LootTableEntry.create(5,"seashell"),
		LootTableEntry.create(5,"flint"),
		LootTableEntry.create(10,"shorts_plain"),
	]
