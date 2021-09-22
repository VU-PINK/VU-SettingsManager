local SETTINGS_CONFIG = {
    MeshSettings = {
        forceLod = 0,
        globalLodScale = 1000,
        shadowDistanceScale = 1000
    },
    WorldRenderSettings = {
        shadowmapResolution = 4096,
        shadowmapViewDistance = 500,
        shadowmapQuality = 0
    },
    VegetationSystemSettings = {
        maxActiveDistance = 4000,
        shadowMeshEnable = true
    }
}

g_Prints = false

return SETTINGS_CONFIG

