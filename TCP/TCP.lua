--[[
    TCP.lua
    A simple TCP-like implementation for rednet in ComputerCraft.
    This module allows you to send and receive packets over rednet channels.
    It uses a packet ID to ensure that packets are received in order and can be forced to beacknowledged.
]]--

local TCP = {}
TCP.__index = TCP
--[[
    Settup a TCP object that can send and receive packets from a target
    @param SendChannel: The channel to send packets on
    @param ReceiveChannel: The channel to receive packets on
    @param packetID: The ID of the packet to be sent
    @param packets: A table to store the packets that are sent
    @param timer: A timer to wait for ACKs
    @param RequestDelay: The delay before a packet is re Requested (s)
]]--

--[[
    Example usage:
    
    In Your main program:
    local TCP = require "TCP"
    --INITIALIZE THE TCP OBJECT
    local Connection = TCP:Settup(Settings)

    local function mainLoop()
        while true do
            -- your main logic goes here
            print("Doing main tasks...")
            sleep(2)
            packetout = {data = "Hello World"}
            Connection:sendPacket(packetout, true) -- Send packet and wait for ACK retuns boolean of success


            --example of reading received packets
            local newpackets = Connection:recivedPackets("new") -- returns empty table if no packets are received

        end
    end

    parallel.waitForAny(mainLoop, Connection.Coroutine)
]]--


-- Update function from github
local code_base = "BlockheedMartin_CC_TCP"
local url = "https://github.com/desuarez17/BlockheedMartin_CC/blob/main/TCP/TCP.lua"
local versionUrl = "https://github.com/desuarez17/BlockheedMartin_CC/blob/main/TCP/version.txt"
local filename = "TCP.lua"
local main = shell.getRunningProgram()
local currentVersion = "0.4" -- change this to your current version

local function fetch(url)
    local response = http.get(url)
    if response then
        local content = response.readAll()
        response.close()
        return content
    end
    return nil
end

local function update()
    local latestVersion = fetch(versionUrl)

    if latestVersion and latestVersion:gsub("%s+", "") ~= currentVersion then
        print("New version of "..code_base.."available: "..latestVersion)
        local newScript = fetch(url)

        if newScript then
            local file = fs.open(filename, "w")
            file.write(newScript)
            file.close()

            print("Updated "..code_base.." to version: "..latestVersion..". Restart recomended")
            sleep(1)
        else
            print("Update failed: Couldn't fetch new script.")
        end
    else
        --print("Already up-to-date (version "..currentVersion..")")
    end
end

function TCP:Settup(Settings)
    update() -- Check for updates on load
    local default = {
        SendChannel = 420,
        ReceiveChannel = 666,
        packetID = 0,
        packets = {},
        timer = nil,
        Paired = false,
        RequestDelay = 5,
        MaxPacketOutgoing = 10,
        AllowRemote = true,
        protocol = "TCP:"..currentVersion
    }

    local obj = {}
    if Settings != nil then
        obj = tableUpdate(default, Settings)
    else
        obj = default
    end

    --Host on TCP channel
    rednet.host(self.protocol, "ID:" .. os.getComputerID()..",Label:"..os.getComputerLabel())

    setmetatable(obj, self)

    --Attempt to pair with the target
    if TCP.sendPacket(obj, {id = obj.packetID}, True) then
        obj.paired = true
    else
        obj.paired = false
        print("Failed to pair with target, please check your settings")
        print("SendChannel: " .. obj.SendChannel)
        print("ReceiveChannel: " .. obj.ReceiveChannel)
        print("PacketID: " .. obj.packetID)
    end

    return obj
end
function TCP:QueueSendPacket(data, ForceACK)
    --Placeholder fuunction
end

function TCP:sendPacket(data,ForceACK)
    if ForceACK == nil then ForceACK = true end
    self.packetID = self.packetID + 1
    local packet = {
        id = self.packetID,
        data = data,
        timestamp = os.time(),
        senderID = os.getComputerID(),
        ForceACK = ForceACK,
    }
    self.packets[self.packetID] = packet
    rednet.send(self.SendChannel, packet)
    if ForceACK then -- Wait for for packet to be returned
        self.timer = os.startTimer(self.RequestDelay)
        while true do
            local event, p1, p2, p3, p4 = os.pullEvent()
            if event == "rednet_message" then
                local senderID, message = p2, p3
                if message.id == self.packetID and message.data == "ACK" then
                    return true -- ACK received
                end
            elseif event == "timer" and p1 == self.timer and self.paired then
                return false -- Timeout
            end
            if event == "timer" and p1 == self.timer and not self.paired then
                -- print("Failed to receive ACK, resending packet")
                rednet.send(self.SendChannel, packet)
                self.timer = os.startTimer(self.RequestDelay)
            end
        end
    else
        os.queueEvent("PacketSent", self) -- Queue an event for the packet sent (PacketSent, socket)
        return true -- No ACK required
    end
end
function TCP:RecivedPackets(mode)
    --Returns a table of packets that have been received since the last call to this function
    local list = {}
     while true do
        -- 0‑second timeout: don’t wait, just check the queue
        local id, msg, protocol = rednet.receive(self.protocol,0)
        if not id then break end           -- queue is empty

        --ACK the packet if it is a valid packet
        if msg.id and msg.data and msg.ForceACK then --Valid packet arrived to be ACKed
            rednet.send(id, {id = msg.id, data = "ACK"})
        end

        list[#list + 1] = {id = id, msg = msg, protocol = protocol}
    end
    
    self.packets = list -- Store the packets in the object

    if mode == "new" then
        return list -- Returns a table of new packets
    elseif mode == "all" then
        return self.packets -- Returns all packets
    else
        print("TCP:RecivedPackets: Invalid mode "..mode.." specified")
        return nil -- Invalid mode
    end
end
function TCP:Coroutine()
    self.timer = os.startTimer(self.RequestDelay)
    while true do --This is a coroutine that will run in the background
        local event, p1, p2, p3, p4 = os.pullEvent()
         if event == "rednet_message" then
            local senderID, message = p2, p3
            if message.id and message.data then --Valid packet arrived
                if message.ForceACK then
                    rednet.send(senderID, {id = message.id, data = "ACK"})
                end
                return message
            end
        elseif event == "timer" and p1 == self.timer then --our timer expired
            return nil -- Timeout
        end
    end
end


--Helper fxns
function tableUpdate(dest, src)
    for k, v in pairs(src) do
        dest[k] = v
    end
    return dest
end

return TCP