--[[
    Notes:
        optimisedWait and pause is windows only!
        createFile contents is nullable and not required!
        (reminder) for lua file paths use / not \
]]

local module = {
    version = 0.1;
    promptFunction = {
        declinedMessage = "Prompt was declined as the user didn't type y.",
        doDeclineMessage = false
    },
    universalPause = {
        pauseMessage = "Click enter to continue"
    },
    extensions = {
        "LuaV.extensions.example",
    },
    extensionSettings = {
        announceLoadedExtensions = false
    }
}

return module