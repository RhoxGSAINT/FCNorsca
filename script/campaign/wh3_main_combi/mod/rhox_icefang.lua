local icefang_faction = "wh_dlc08_nor_vanaheimlings"

local storm_duration = 3

core:add_listener(
	"icefang_garrison_occupied_even",
	"GarrisonOccupiedEvent",
	function(context)
		local faction = context:character():faction();
		local settlement = context:garrison_residence():settlement_interface()
		
		if not settlement then
            return false
		end
		local climate = settlement:get_climate()
		return faction:name() == icefang_faction and (climate=="climate_frozen" or climate=="climate_chaotic")
	end,
	function(context)
		local character = context:character()
		cm:create_storm_for_region(character:region():name(), 1, storm_duration, "ksl_winter");
		cm:apply_effect_bundle_to_region("rhox_icefang_region_winter_storm", character:region():name(), storm_duration)
	end,
	true
);
