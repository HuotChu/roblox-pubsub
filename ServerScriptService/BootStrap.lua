--[[
    // Filename: BootStrap.lua
    // Version 1.0
    // Release 1
    // Written by: HuotChu/BluJagu/ScottBishop
    // Description: Enables the Server to create RemoteEvents requested by the Client
]]--

local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local PubSub = require(ReplicatedStorage:WaitForChild('PubSub'))

--  --  --  --  --
--  If PubSub let the Client create RemoteEvents, the Server would not know, so PubSub fails.
--  Allowing the Server to create all the RemoteEvents keeps everything working nicely.
--  --  --  --  --

local CreateRemoteEvent = PubSub:FindFirstChild('CreateRemoteEvent')

local onCreateRemoteEvent = function (player, t)
    return PubSub.createEvent(t)
end

CreateRemoteEvent.OnServerInvoke = onCreateRemoteEvent

--  --  --  --  --
--  When a player leaves, remove their Client-requested RemoteEvents with PubSub.removePlayer(/*Player.Name*/)
--  Also, this cleans up any player specific topics, ie.
--  --  Server can send an event to a specific player: PubSub.publish(Player.Name..'_ScoreChange', newScore)
--  --  Client listens: PubSub.subscribe(game.Players.LocalPlayer.Name..'_ScoreChange', function (newScore) script.Parent.Text = newScore end, 'PlayerGui')
--  --  The convention is PlayerName_EventName, where EventName can be any name you create to represent this event, ie. 'ScoreChange'
--  --  --  --  --

--[[ uncomment next 3 lines to use ]]--
--Players.PlayerRemoving:connect(function (player)
--    PubSub.removePlayer(player.Name)
--end)

--  --  --  --  --
--  Generic events can be listened to by all Client UI components, all Server components, and all Workspace components!
--  Example workspace part script contains: PubSub.subscribe('ChangePartColor', function (color) part.BrickColor = BrickColor.new(color) end, 'myPart')
--  Client and Server BOTH could publish to change the part color: Pubsub.publish('ChangePartColor', 11)
--  If passing multiple values as arguments, just add commas: Pubsub.publish('ChangePartColor', 11, 'Slate', {Enabled=true})
--  Only want the Client to hear Client events or Server only hears Server events?
--  PubSub.subscribe('ChangePartColor', changePartFunction, 'myPart', 'noRemote')
--  'noRemote' prevents the API from connecting the event handler to a RemoteEvent
--  Now, only is the server publishes 'ChangePartColor', the color will change...
--  but if the Client publishes 'ChangePartColor', no event handler will fire to change the color
--  --  --  --  --


--[[ Example Usage ]]--
--local OnPlayerJoined = function (playerName) print(playerName..' joined the game!') end
--PubSub.subscribe('PlayerJoined', OnPlayerJoined, 'BootStrap', 'noRemote')
--Players.PlayerAdded:connect(function (player)
--    PubSub.publish('PlayerJoined', player.Name)
--end)


-- If the Client was publishing 'PlayerJoined' and we wanted to fire OnPlayerJoined, exclude 'noRemote'



