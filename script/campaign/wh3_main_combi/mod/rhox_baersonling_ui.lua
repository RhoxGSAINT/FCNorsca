local baersonling_faction ="wh_main_nor_baersonling"


local function rhox_baersonling_god_bar_ui()
    local norsca_gods_frame = find_uicomponent(core:get_ui_root(), "hud_campaign", "resources_bar_holder", "resources_bar", "norsca_favour", "norsca_gods_frame")
    if not norsca_gods_frame then
        return
    end
    norsca_gods_frame:SetImagePath("ui/skins/default/nor_gods_bg_baersonling.png")
    for i = 0, norsca_gods_frame:ChildCount() - 1 do
        local current_list = UIComponent(norsca_gods_frame:Find(i))
        if not current_list then
            return
        end
        local current_id = current_list:Id()
        if current_id == "list_hound" or current_id == "list_serpent" or current_id == "list_crow" then
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


local function rhox_baersonling_loop_and_change_icon()
    local list_box = find_uicomponent(core:get_ui_root(), "character_details_panel", "character_context_parent", "tab_panels", "character_initiatives_holder", "path_to_glory_holder", "holder_marks", "list_box")
    if not list_box then
        return
    end
    for i = 0, list_box:ChildCount() - 1 do
        local current_initiative = find_child_uicomponent_by_index(list_box, i)
        if not current_initiative then
            return
        end
        local dy_chs_souls = find_uicomponent(current_initiative, "dy_chs_souls", "chs_souls_icon")
        if dy_chs_souls then
            dy_chs_souls:SetImagePath("ui/skins/default/norse_god_eagle.png")
        end
            
    end
end


cm:add_first_tick_callback(
    function()
    
        if cm:get_local_faction_name(true) == baersonling_faction then
            local parent_ui = find_uicomponent(core:get_ui_root(), "hud_campaign", "resources_bar_holder", "resources_bar");
            
            core:add_listener(
                "rhox_baersonling_disable_occupation_options",
                "PanelOpenedCampaign",
                function(context)
                    return context.string == "settlement_captured"
                end,
                function(context)
                    local panel = find_uicomponent(core:get_ui_root(), "settlement_captured")
					if not panel then
						return
					end
                    local kill = find_uicomponent(panel, "1963655228")
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
            core:add_listener(
				"rhox_baersonling_character_initiatives_resource_via_panel",
				"PanelOpenedCampaign",
				function(context)
					return context.string == "character_details_panel"
				end,
				function(context)
                    cm:callback(
                            function()
                                rhox_baersonling_loop_and_change_icon()
                            end,
                        0.05
                    )
				end,
				true
			)
			core:add_listener(
				"rhox_baersonling_character_initiatives_resource",
				"ComponentLClickUp",
				function(context)
					return find_uicomponent(core:get_ui_root(), "character_details_panel", "character_context_parent", "TabGroup", "character_initiatives") == UIComponent(context.component)
				end,
				function(context)
                    cm:callback(
                            function()
                                rhox_baersonling_loop_and_change_icon()
                            end,
                        0.05
                    )
				end,
				true
			)
            
            rhox_baersonling_god_bar_ui()
            
        end
        
    end
)


