local akkorak_faction ="wh3_dlc20_nor_kul"


local knight_list={
    "wh3_dlc20_chs_cav_chaos_knights_mkho",
    "wh3_main_tze_cav_chaos_knights_0",
    "wh3_dlc20_chs_cav_chaos_knights_mnur",
    "wh3_dlc20_chs_cav_chaos_knights_msla",
    "wh_main_chs_cav_chaos_knights_0",
}
local knight_lance_list={
    "wh3_dlc20_chs_cav_chaos_knights_mkho_lances",
    "wh3_dlc20_chs_cav_chaos_knights_mtze_lances",
    "wh3_dlc20_chs_cav_chaos_knights_mnur_lances",
    "wh3_dlc20_chs_cav_chaos_knights_msla_lances",
    "wh_main_chs_cav_chaos_knights_1",
}



core:add_listener(
    "rhox_akkorak_region_turn_start",
    "RegionTurnStart",
    function(context)
        local region = context:region()
        local owner_faction = region:owning_faction()
        local bonus_value = region:bonus_values():scripted_value("rhox_akkorak_knight_chance", "value")
        return cm:model():random_percent(bonus_value) and owner_faction and owner_faction:name() == akkorak_faction
    end,
    function(context)
        local region = context:region()
        local owner_faction = region:owning_faction()
        cm:add_units_to_faction_mercenary_pool(owner_faction:command_queue_index(), knight_list[cm:random_number(#knight_list)], 1)
        cm:add_units_to_faction_mercenary_pool(owner_faction:command_queue_index(), knight_lance_list[cm:random_number(#knight_lance_list)], 1)
    end,
    true
);



cm:add_first_tick_callback(
    function()
        if cm:get_local_faction_name(true) == akkorak_faction then
            local parent_ui = find_uicomponent(core:get_ui_root(), "hud_campaign", "resources_bar_holder", "resources_bar");
            local result = core:get_or_create_component("rhox_akkorak_horse_holder", "ui/campaign ui/rhox_akkorak_horse_holder.twui.xml", parent_ui)            
        end
    end
)
