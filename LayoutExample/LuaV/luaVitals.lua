local module = {}

local config = require("LuaV.LuaVitalsAssets.config")
local json = require("LuaV.LuaVitalsAssets.External.json")

function module.pause()
    os.execute("pause")
end

function module.UniversalPause()
    io.write(config.universalPause.pauseMessage)
    io.read()
end

function module.upause()
    module.UniversalPause()
end

function module.tableToJson(tableValue)
    return json.encode(tableValue)
end

function module.jsonToTable(jsonTable)
    return json.decode(jsonTable)
end

function module.splitString(text,seperator)
    local stringTable = {}

    local stringSet = {}

    for i=1,#text,1 do
        local letter = string.sub(text,i,i)

        if letter == seperator then
            table.insert(stringTable,table.concat(stringSet))
            stringSet = {}
        else
            table.insert(stringSet,letter)
        end
    end

    if stringSet ~= {} then
        table.insert(stringTable,table.concat(stringSet))
    end

    return stringTable
end

function module.encrypt(text,pass)
	local Encry = ""

	for i=1,string.len(text),1 do
		local utfc=utf8.codepoint(text,i,i) +pass

		if utfc == nil then return end

        if utf8.char(utfc) then
            utfc = utf8.char(utfc)
        end

		Encry = Encry..utfc.."-"
	end

	return Encry
end

function module.decrypt(encrypted,pass)
    local decry=""
	local s,e=pcall(function()

		local encryTable = module.splitString(encrypted,"-")

		for i,v in pairs(encryTable) do
			if v ~= "-" and v ~= "" then
				local utfc = utf8.codepoint(v,1,1) -pass

				local char = utf8.char(utfc)

				decry=decry..char
			end
		end
	end)

	if e then
		print("Damaged result: "..e)
	end

    return decry
end

function module.repString(str,count)
    local convertedstr = ""

    for i=0,count,1 do
        convertedstr = convertedstr..str
    end

    return convertedstr
end

function module.prompt(promptText,func)
    io.write(promptText.." to continue or not continue type y/n: ")
    local promptResponse = io.read()

    if promptResponse == "y" then
        func()
    elseif config.promptFunction.doDeclineMessage == true then
        print(config.promptFunction.declinedMessage)
    end
end

function module.wait(time)
    local beginTick = os.time()

    repeat until os.time() - beginTick >= time
end

function module.optimisedWait(time)
    os.execute("TIMEOUT /T "..time.." /NOBREAK")
end

function module.createFile(path,fileName,contents)

    local file
    if path == "" then
        file = io.open(fileName,"a+")
    else
        file = io.open(path.."/"..fileName,"a+")
    end
    
    if file then
        if contents then
            file:write(contents)
        end
    else
        print("[Create file]: couldn't fetch folder path.")
    end
end

function module.readFile(filePath)
    local file = io.open(filePath,"r")

    if not file then
        print("[Read file]: couldn't fetch folder path and failed to find the file.")
        return
    end

    local contents = file:read("a*")

    local a = 0

    while contents == "" do
        a = a +1
        contents = file:read("a*")
        if a >= 20 then
            print("[Read file]: There's no file contents!")
            break
        end
    end

    return contents
end

function module.fileExists(filePath)
    local file = io.open(filePath,"r")

    if not file then
        return false
    end
    
    return true
end

function module.writeToFile(filePath,contents)
    local file = io.open(filePath,"w")

    if file then
        file:write(contents)
    else
        print("[Write file]: couldn't fetch folder path.")
    end
end

function module.input(prompt)
    io.write(prompt)
    return io.read()
end

function module.textUserInput(prompt)
    module.input(prompt)
end

--shortened versions
function module.oWait(time)
    module.optimisedWait(time)
end

function module.windowsWait(time)
    module.oWait(time)
end

--other functions

function module.delayFunction(delay,func)
    coroutine.wrap(function()
        module.wait(delay)
        func()
    end)()
end

--extensions

for _,extension in pairs(config.extensions) do
    local extension = require(extension)

    if config.extensionSettings.announceLoadedExtensions == true then
        print("loading extension "..extension.extensionName)
    end

    for funcName,func in pairs(extension.functions) do

        if config.extensionSettings.announceLoadedExtensions == true then
            print("added function: "..funcName.." to luaEssentials")
        end

        module[funcName] = func
    end

    if config.extensionSettings.announceLoadedExtensions == true then
        print("successfully loaded extension")
        print("name: "..extension.extensionName)
        print("description: "..extension.description)
        print("-----")
    end
end

return module