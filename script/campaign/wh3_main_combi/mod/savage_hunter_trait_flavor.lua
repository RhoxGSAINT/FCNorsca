
-----------------------------------------------
------------ Trait Giving Listener ------------
-----------------------------------------------


core:add_listener(
	"rhox_fc_norsca_hunter_trait_flavor",
	"CharacterCreated",
	function(context)
		return context:character():character_subtype("nor_skin_wolf_lord") and not context:character():has_trait("savage_hunter_trait_savage_hunter");
	end,
	function(context)		
		cm:force_add_trait(cm:char_lookup_str(context:character():cqi()), "savage_hunter_trait_savage_hunter");
	end,
	true
);
