local chatBox = peripheral.find("chatBox")
-- chatBox.sendMessage(":heart: §1.Gay.§r"..os.date("%Y-%m-%d %H:%M:%S"), "§1.BlockeedQuarryMaster.§r")

target = "amfs987"
target = "desuarez"


local spectatorlist = {
    "amfs987",
    "desuarez",
    "crabbywings_15",
}
local msglist = {
    "Botboy",
    "-1 Rep",
    "Ask someone else",
    "Stop lagging the server",
    "Stop spamming",
    "Stop being annoying",
    "Stop being a bot",
    "Stop being a botboy",
    "botboy.exe",
    "botboy is a bot",
    "botboy is a botboy",
    "Go message a real mod",
    "Everone ignore this botboy",
}

local msgcopy = msglist

local msgcnt = 0 
while true do
    local event, username, message = os.pullEvent("chat")
    if username == target then
        msgcnt = msgcnt + 1
        print("Message from " .. username .. ": " .. message .. " (Strike: " .. msgcnt .. ")")
    else
        print("Strike reset for " .. username)
        msgcnt = 0
        msgcopy = msglist
    end
    if username == target and msgcnt > 1 then --exicute
        if #msgcopy == 0 then
            print("No more messages to send. Resetting message list.")
            msgcopy = msglist
        end
        i = math.random(1, #msgcopy)
        local msg = msgcopy[i]
        table.remove(msgcopy, i)
        
        chatBox.sendMessage(msg,"Mod Aproval board")
    end
end
