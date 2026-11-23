local modules = {
    framework = { configKey = "Framework", "kora_core", "qbx_core", "qb-core", "es_extended" },
    inventory = { configKey = "Inventory", "kora_inventory", "ox_inventory", "wasabi_inventory", "m-Inventory", "one_inventory", "jaksam_inventory", "tgiann-inventory", "codem-inventory", "core_inventory", "origen_inventory", "qs-inventory", "qb-inventory" },
    target = { configKey = "Target", "kora_target", "ox_target", "tgiann-target", "core_focus", "qb-target", "sleepless_interact" },
    vehiclekeys = { configKey = "VehicleKeys", "MrNewbVehicleKeys", "qbx_vehiclekeys", "cd_garage", "mVehicle", "okokGarage", "qb-vehiclekeys", "vehicles_keys", "wasabi_carlock", "Renewed-Vehiclekeys", "mk_vehiclekeys", "ak47_vehiclekeys", "0r-vehiclekeys" },
    vehiclefuel = { configKey = "VehicleFuel", fallback = "internal", "ox_fuel", "rcore_fuel", "okokGasStation", "LegacyFuel", "cdn-fuel", "lc_fuel", "qb-fuel", "Renewed-Fuel", "ps-fuel", "qs-fuelstations", "ti_fuel" },
    menu = { configKey = "Menu", "ox_lib", "lation_ui", "qb-menu" },
    notifications = { configKey = "Notifications", fallback = "internal", "ox_lib", "vms_notifyv2", "codem-notification", "brutal_notify", "fl-notify", "mythic_notify", "okokNotify", "pnotify", "solaire_notify", "t-notify", "lation_ui", "wasabi_notify", "zsx_uiv2" },
    inputs = { configKey = "Inputs", "ox_lib", "lation_ui" },
    textui = { configKey = "TextUI", "ox_lib", "lation_ui", "okokTextUI", "cd_drawtextui", "jg-textui", "lab-TextUI", "zsx_uiv2" },
    progressbar = { configKey = "ProgressBar", "ox_lib", "lation_ui", "wasabi_uikit", "progressbar", "zsx_uiv2" },
    bossmenu = { configKey = "BossMenu", "qbx_management", "qb-management", "esx_society", "vms_bossmenu", "tk_bosstablet", "okokBossMenu", "codem-bossmenu", "zat-bossmenu", "m-BossMenu", "ShitDevScripts-Bossmenu" },
    dispatch = { configKey = "Dispatch", fallback = "internal", "ps-dispatch", "cd_dispatch", "tk_dispatch", "rcore_dispatch", "lb-tablet", "origen_police", "core_dispatch", "kartik-mdt", "codem-dispatch", "wasabi_mdt", "redutzu-mdt" },
    banking = { configKey = "Banking", fallback = "internal", "qb-banking", "Renewed-Banking", "okokBanking", "fd_banking", "kartik-banking", "wasabi_banking", "tgiann-bank", "tgg-banking", "ShitDevScripts-Banking" },
    doorlock = { configKey = "Doorlock", fallback = "internal", "ox_doorlock", "qb-doorlock", "rcore_doorlock", "doors_creator" },
    housing = { configKey = "Housing", fallback = "internal", "ps-housing", "qb-houses", "qb-appartments", "bcs-housing", "esx_property" },
    phone = { configKey = "Phone", fallback = "internal", "lb-phone", "gksphone", "okokPhone", "qb-phone", "qs-smartphone", "yseries" },
    shops = { configKey = "Shops", fallback = "internal" },
    skills = { configKey = "Skills", fallback = "internal", "evolent_skills", "OT_skills", "pickle_xp" },
    weather = { configKey = "Weather", fallback = "internal", "cd_easytime", "qb-weathersync", "renewed-weathersync" },
    zones = { configKey = "Zones", "ox_lib", "polyzone" },
}

local function resolveAuto(entry, value)
    if value ~= nil and value ~= "auto" then return value end

    for _, resource in ipairs(entry) do
        if GetResourceState(resource) == "started" then
            return resource
        end
    end

    for _, resource in ipairs(entry) do
        if GetResourceState(resource) ~= "missing" then
            return resource
        end
    end

    return entry.fallback
end

Config.Providers = {}

for module, entry in pairs(modules) do
    local configured = Config[entry.configKey]
    local resolved = resolveAuto(entry, configured)
    if not resolved then
        print(("^3[Fivem_Bridge] No installed provider found for %s (Config.%s = \"auto\"). Install a supported resource or set an explicit provider.^0"):format(module, entry.configKey))
    end
    Config[entry.configKey] = resolved
    Config.Providers[module] = resolved
end
