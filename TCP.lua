--[[
    TCP.lua
    A simple TCP-like implementation for rednet in ComputerCraft.
    This module allows you to send and receive packets over rednet channels.
    It uses a packet ID to ensure that packets are received in order and can be forced to beacknowledged.
]]--

local TCP = {}


--[[
    Settup a TCP object that can send and receive packets from a target
]]--
function TCP.Settup()
    local obj = {
        SendChannel = 420,
        ReceiveChannel = 666,
        packetID = 0,
        packets = {},
        timer = nil,
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end
function TCP.sendPacket(data,ForceACK)
    if ForceACK == nil then ACKForceACK = true end
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
end
function TCP.receivePacket(timeout)
    self.timer = os.startTimer(timeout or 5)
    while true do
        local event, p1, p2, p3, p4 = os.pullEvent()
        if event == "rednet_message" then
            local senderID, message = p2, p3
            if message.id and message.data then
                return message
            end
        elseif event == "timer" and p1 == self.timer then
            return nil -- Timeout
        end
    end
end

return TCP