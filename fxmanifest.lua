fx_version "cerulean"
game "gta5"
lua54 "yes"

name "Fivem_Bridge"

author "ShitDevScripts"
description "Fivem_Bridge is a framework agnostic resource that provides a simple way to create bridges between your resources and other resources. It is designed to be easy to use and understand, while also being powerful enough to handle complex use cases."
version "0.0.6"

dependencies {
    "ox_lib",
}

shared_scripts {
    "@ox_lib/init.lua",
    "config/bridge_resources.lua",
    "config/theme.lua",
    "config/auto_detect.lua",
    "utility/shared/shims.lua",
    "import.lua",
    "utility/shared/locale.lua",
}

ui_page "web/build/index.html"

client_scripts {
    "utility/client/interaction_points.lua",
    "utility/client/interactions.lua",
    "utility/client/gizmo.lua",
    "utility/client/keybinds.lua",
    "utility/client/placer.lua",
    "utility/client/dialogue.lua",
    "utility/client/zone_creator.lua",
    "utility/client/dui_surface.lua",
    "utility/client/task_groups.lua",
    "utility/client/task_hud.lua",
}

server_scripts {
    "@oxmysql/lib/MySQL.lua",
    "utility/server/interactions.lua",
    "utility/server/task_groups.lua",
    "utility/server/version.lua",
}

files {
    "import.lua",
    "modules/**/client.lua",
    "modules/**/server.lua",
    "modules/**/shared.lua",
    "modules/framework/*.lua",
    "locales/*.json",
    "types/**/*.lua",
    "utility/client/*.lua",
    "web/build/**",
}

exports {
    "BridgeEnvironment",
    "Framework",
    "Inventory",
    "Banking",
    "Locale",
    "Locales",
    "GetTheme",
    "GetThemeCss",
    "Dialogue",
    "PropPlacer",
    "useGizmo",
    "GetBoundKey",
    "RegisterCommand",
    "RegisterKeybind",
    "AddInteraction",
    "AddInteractionsBatch",
    "CancelInteractionBatch",
    "BeginInteractionBulk",
    "CommitInteractionBulk",
    "RemoveInteraction",
    "UpdateInteraction",
    "RemoveAllInteractions",
    "GetClosestInteraction",
    "GetNearbyInteractions",
    "GetInteractionByEntity",
    "VersionCheck",
    "CreateZone",
    "CreateDuiPlacement",
    "CreateLaserTargetPlacement",
    "RegisterDuiSurface",
    "UpdateDuiSurface",
    "UnregisterDuiSurface",
    "ClearDuiSurfaces",
    "HasDuiPlacement",
    "GetDuiBoardCenter",
    "GetDuiTargetRadius",
    "ApplyPropDuiTexture",
    "UpdatePropDuiTexture",
    "ClearPropDuiTexture",
    "HasPropDuiTexture",
    "CreateTaskGroup",
    "AddToTaskGroup",
    "RemoveFromTaskGroup",
    "ClearTaskGroup",
    "DeleteTaskGroup",
    "IsInTaskGroup",
    "IsTaskGroupLeader",
    "GetTaskGroupLeader",
    "SetTaskGroupLeader",
    "GetTaskGroupMembers",
    "GetPlayerTaskGroups",
    "GetTaskGroupMemberCount",
    "GetLocalTaskGroups",
    "TaskGroups",
    "OpenTaskGroupMenu",
    "CloseTaskGroupMenu",
    "IsTaskGroupMenuOpen",
    "Notify",
    "Task",
    "CompleteTask",
}
