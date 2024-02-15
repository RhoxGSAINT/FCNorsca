local aesling_faction ="wh_main_nor_aesling"

core:add_listener(
    "rhox_aesling_CharacterPerformsSettlementOccupationDecisionSummonArmy",
    "CharacterPerformsSettlementOccupationDecision",
    function(context)
        return context:occupation_decision() == "1963655228" and context:character():faction():name() == aesling_faction
    end,
    function(context)
        local region = context:garrison_residence():settlement_interface():region()
        local character = context:character()

        khorne_spawned_armies:spawn_army(region, character)
        
    end,
    true
);



local function rhox_aesling_god_bar_ui()
    local norsca_gods_frame = find_uicomponent(core:get_ui_root(), "hud_campaign", "resources_bar_holder", "resources_bar", "norsca_favour", "norsca_gods_frame")
    if not norsca_gods_frame then
        return
    end
    norsca_gods_frame:SetImagePath("ui/skins/default/nor_gods_bg_aesling.png")
    for i = 0, norsca_gods_frame:ChildCount() - 1 do
        local current_list = UIComponent(norsca_gods_frame:Find(i))
        if not current_list then
            return
        end
        local current_id = current_list:Id()
        if current_id == "list_eagle" or current_id == "list_serpent" or current_id == "list_crow" then
            for j = 0, current_list:ChildCount() - 1 do
                local current_tier = UIComponent(current_list:Find(j))
                if not current_tier then
                    return
                end
                current_tier:SetVisible(false)
            end
        end		
    end
end




cm:add_first_tick_callback(
    function()
    
        if cm:get_local_faction_name(true) == aesling_faction then
            core:add_listener(
                "rhox_aesling_disable_vanilla_occupation_options",
                "PanelOpenedCampaign",
                function(context)
                    return context.string == "settlement_captured"
                end,
                function(context)
                    local panel = find_uicomponent(core:get_ui_root(), "settlement_captured")
                    local kill = find_uicomponent(panel, "1292694896")
                    local maim = find_uicomponent(panel, "1369123792")
                    local burn = find_uicomponent(panel, "1824195232")
                            
                    if kill then 
                        kill:SetVisible(false)
                    end
                    if maim then
                        maim:SetVisible(false)
                    end
                    if burn then
                        burn:SetVisible(false)
                    end  
                end,
                true
            )
            

            local parent_ui = find_uicomponent(core:get_ui_root(), "hud_campaign", "resources_bar_holder", "resources_bar");
            
            local result = core:get_or_create_component("rhox_aesling_skull_throne", "ui/campaign ui/rhox_aesling_skull_throne.twui.xml", parent_ui)
            result:SetContextObject(cco("CcoCampaignFaction", aesling_faction))
            local result2 = core:get_or_create_component("rhox_aesling_skull_holder", "ui/campaign ui/rhox_aesling_skull_holder.twui.xml", parent_ui)
            
            rhox_aesling_god_bar_ui()
        end
        
    end
)
