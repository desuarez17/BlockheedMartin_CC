local chatBox = peripheral.find("chatBox")

target = "amfs987"
target = "desuarez"
--target = "dogboy331"


local deliverylist = {
    "desuarez",
    "amfs987",
    "crabbywings_15",
    "OrbitalObject",
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

function contains(tbl, val)
    for _, v in ipairs(tbl) do
        if v == val then
            return true
        end
    end
    return false
end

if not contains(deliverylist, target) then
    table.insert(deliverylist,target)
end

for i, player in ipairs(deliverylist) do
    print("Sending message to " .. player)
    chatBox.sendMessageToPlayer("Mod Aproval board is now online. Please report any botboys to the board.", player, "Mod Aproval board")
end
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
        
        for k, player in ipairs(deliverylist) do
            chatBox.sendMessageToPlayer(msg,player,"Mod Aproval board")
        end
    end
end
