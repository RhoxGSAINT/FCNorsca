local khorne_factions = {
	mixer_nor_bloodfjord = true,
	mixer_nor_snaegr = true
}

local function rhox_bloodfjord_god_bar_ui()
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
    
        if khorne_factions[cm:get_local_faction_name(true)] then
            core:add_listener(
                "rhox_bloodfjord_disable_vanilla_occupation_options",
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
            rhox_bloodfjord_god_bar_ui()
        end
        
    end
)
