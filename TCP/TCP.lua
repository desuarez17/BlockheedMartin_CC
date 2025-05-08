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
    Settup a TCP object that can send and receive packets from a target
]]--
function TCP.Settup(Settings)
    local default = {
        SendChannel = 420,
        ReceiveChannel = 666,
        packetID = 0,
        packets = {},
        timer = nil,
        Paired = false,
        RequestDelay = 5,
    }

    local obj = {}
    if Settings != nil then
        obj = tableUpdate(default, Settings)
    else
        obj = default
    end
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
        return true -- No ACK required
    end
end
function TCP:receivePacket(timeout)
    self.timer = os.startTimer(timeout or 5)
    while true do
        local event, p1, p2, p3, p4 = os.pullEvent()
        if event == "rednet_message" then
            local senderID, message = p2, p3
            if message.id and message.data then --Valid packet arrived
                if message.ForceACK then
                    rednet.send(senderID, {id = message.id, data = "ACK"})
                end
                return message
            end
        elseif event == "timer" and p1 == self.timer then
            return nil -- Timeout
        end
    end
end
function TCP:Coroutine()
    while true do --This is a coroutine that will run in the background
        local event, p1, p2, p3, p4 = os.pullEvent()
        
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