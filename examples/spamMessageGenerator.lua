local luaVitals = require("LuaV.luaVitals")

print("Spam message generator!")

local message = luaVitals.input("what message would you like to spam? ")
local count = luaVitals.input("how many times do you want to spam it? ")

print("here's your text: ")

local s,e = pcall(function()
    print(luaVitals.repString(message.." ",count))
end)

if e then
    print("only put numbers when I tell you how many times you want to spam it!")
end