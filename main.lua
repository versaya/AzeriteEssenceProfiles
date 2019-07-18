AZERITE_ESSENCE_PROFILES_ADDON = AZERITE_ESSENCE_PROFILES_ADDON or LibStub("AceAddon-3.0"):NewAddon("AZERITE_PRESETS_ADDON", "AceConsole-3.0")
local t = AZERITE_ESSENCE_PROFILES_ADDON
t.ADDON_NAME = "AzeriteEssenceProfiles"

t.presets = {}


local addonLoadedFrame = CreateFrame("Frame")
addonLoadedFrame:RegisterEvent("ADDON_LOADED")
addonLoadedFrame:SetScript("OnEvent", function(self, event, addon)
    local t = AZERITE_ESSENCE_PROFILES_ADDON

    if addon == t.ADDON_NAME then
        if AzeriteEssenceProfiles == nil then
            AzeriteEssenceProfiles = {}
        end

        t.presets = AzeriteEssenceProfiles
    end
end)



t.print = function(msg)
   print("|cff60d4d4AEP: |r"..msg)
end

t.SLOT_MAJOR = 115
t.SLOT_MINOR1 = 116
t.SLOT_MINOR2 = 117

t.aui = C_AzeriteEssence



t.printUsage = function()
   print("|cff60d4d4Azerite Essence Profiles|r command list: ")
   t.printUsageSave()
   t.printUsageLoad()
   t.printUsageList()
   t.printUsageDelete()
end

t.printUsageSave = function(usage)
	if usage then
		t.print("Usage:")
	end
   print("|cff60d4d4/aep|r |cffffff33save|r |cfffcffb0<name>|r Save your current Azerite Essence setup as <name>.")
end
t.printUsageLoad = function(usage)
	if usage then
		t.print("Usage:")
	end
   print("|cff60d4d4/aep|r |cffffff33load|r |cfffcffb0<name>|r Load the Azerite Essence setup previously saved as <name>.")
end
t.printUsageList = function(usage)
	if usage then
		t.print("Usage:")
	end
   print("|cff60d4d4/aep|r |cffffff33list|r List all saved profiles.")
end
t.printUsageDelete= function(usage)
	if usage then
		t.print("Usage:")
	end
   print("|cff60d4d4/aep|r |cffffff33delete|r |cfffcffb0<name>|r Delete the profile <name>.")
end

t.get_preset_string = function(name, preset)

	names = {major="<none>", minor1="<none>", minor2="<none>"}

	if preset.major then
		names.major = t.aui.GetEssenceInfo(preset.major).name or "<none>"
	end
	if preset.minor1 then
		names.minor1 = t.aui.GetEssenceInfo(preset.minor1).name or "<none>"
	end
	if preset.minor2 then
		names.minor2 = t.aui.GetEssenceInfo(preset.minor2).name or "<none>"
	end

	return "\"|cffffff33"..name.."|r\" ("..names.major.." / "..names.minor1.." / "..names.minor2..")"

	
end

t.load_preset = function(name)
   if not t.presets[name] then
      t.print("Preset '"..name.."' does not exist...")
   else
      preset = t.presets[name]
      
      if preset.major then
         t.aui.ActivateEssence(preset.major, t.SLOT_MAJOR)
      end
      if preset.minor1 then
         t.aui.ActivateEssence(preset.minor1, t.SLOT_MINOR1)
      end
      if preset.minor2 then
         t.aui.ActivateEssence(preset.minor2, t.SLOT_MINOR2)
      end

      t.print("Loaded "..t.get_preset_string(name, preset))
   end
end


t.save_preset = function(name)
   major = t.aui.GetMilestoneEssence(t.SLOT_MAJOR)
   minor1 = t.aui.GetMilestoneEssence(t.SLOT_MINOR1)
   minor2 = t.aui.GetMilestoneEssence(t.SLOT_MINOR2) 
   
   preset = {major=major,minor1=minor1,minor2=minor2}
   
   
   t.presets[name] = preset
   t.print("Saved "..t.get_preset_string(name, preset))
   
   
   
   
   
   
end

t.delete_preset = function(name)
	t.presets[name] = nil
	t.print("Deleted \"|cffffff33"..name.."|r\"")
end

t.list_presets = function()
   if next(t.presets) == nil then
	   t.print("No saved profiles.")
   else
	   for k,v in pairs(t.presets) do
		   t.print(t.get_preset_string(k,v))
	   end
   end
end


t:RegisterChatCommand("aep", function(msg, editbox)
      local t = AZERITE_ESSENCE_PROFILES_ADDON
      
      -- Split on space
      local words = {}
      for word in msg:gmatch("[^ ]+") do 
         table.insert(words, word)
      end
      
      -- if offer command
      if words[1] == "save" then
         table.remove(words, 1)
         local name = table.concat(words, " ")
         -- If no name, print usage
         if name == "" then
            t.printUsageSave(true)
         else
            t.save_preset(name)
         end
         
      elseif words[1] == "delete" then
         table.remove(words, 1)
         local name = table.concat(words, " ")
         -- If no name, print usage
         if name == "" then 
            t.printUsageDelete(true)
         else
            t.delete_preset(name)
         end
      elseif words[1] == "load" then
         table.remove(words, 1)
         local name = table.concat(words, " ")
         -- If no name, print usage
         if name == "" then 
            t.printUsageLoad(true)
         else
            t.load_preset(name)
         end 
      elseif words[1] == "list" then
         t.list_presets()
      else
         t.printUsage()
      end
      
end)
