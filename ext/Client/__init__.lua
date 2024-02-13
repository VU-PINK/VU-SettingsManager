local SettingsManager = class('SettingsManager')
local SETTINGS_CONFIG = require "__shared/Config"

function SettingsManager:__init()
    if g_Prints then
        print("Initialising SettingsManager")
    end
    self:RegisterVars()
    self:RegisterEvents()
end

function SettingsManager:RegisterVars()
    self.m_UserSettings = {}
end

function SettingsManager:RegisterEvents()
    self.m_OnPlayerSpawn = Events:Subscribe("Player:Respawn" , self, self.OnPlayerSpawn)
    self.m_OnExtensionUnloadEvent = Events:Subscribe('Extension:Unloading', self, self.OnExtensionUnload)
end

function SettingsManager:OnPlayerSpawn()
    if g_Prints then
        print("*Applying Settings")
    end
    self:ApplySettings()
end

function SettingsManager:OnExtensionUnload()
    if g_Prints then
        print("*Resetting Settings")
    end
    self:ResetSettings()
end

function SettingsManager:ApplySettings()
    for l_SettingGroup, l_SettingTable in pairs(SETTINGS_CONFIG) do
        local l_TempSettingGroup = ResourceManager:GetSettings(l_SettingGroup)
        l_TempSettingGroup = _G[l_SettingGroup](l_TempSettingGroup)

        if l_TempSettingGroup then

            if g_Prints then
                print("*Setting " .. tostring(l_SettingGroup))
            end

            for l_Setting, l_Value in pairs(l_SettingTable) do

                if self.m_UserSettings[l_SettingGroup] == nil then
                    self.m_UserSettings[l_SettingGroup] = {}
                end

                if g_Prints then
                    print("*Setting " .. tostring(l_Setting) .. " to " .. tostring(l_Value))
                end
                self.m_UserSettings[l_SettingGroup][l_Setting] = l_TempSettingGroup[l_Setting]
                l_TempSettingGroup[l_Setting] = l_Value
            end
        end
    end
end

function SettingsManager:ResetSettings()
    for l_SettingGroup, l_Settings in pairs(self.m_UserSettings) do
        local l_TempSettingGroup = ResourceManager:GetSettings(l_SettingGroup)
        l_TempSettingGroup = _G[l_SettingGroup](l_TempSettingGroup)

        for l_Setting, l_Value in pairs(l_Settings) do
            if g_Prints then
                print("*Resetting " .. tostring(l_Setting) .. " to " .. tostring(l_Value))
            end
            l_TempSettingGroup[l_Setting] = l_Value
        end
    end
    collectgarbage("collect")
end


-- Singleton.
if g_SettingsManager == nil then
	g_SettingsManager = SettingsManager()
end

return g_SettingsManager