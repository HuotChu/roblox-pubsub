# roblox-pubsub

PubSub for Roblox enables 4 way code communication via an Event Management system.


(Server/Server, Server/Client, Client/Client, Client/Server)

&nbsp;

PubSub works with FilteringEnabled and allows for easy Publish and Subscribe functionality.

&nbsp;

Why is this cool? Well, let's say I wanted to announce a player has joined the game in chat.

&nbsp;

The Player joining is something we connect to on the server [Players.PlayerAdded]

&nbsp;

The chat is on the client, so the server and client need a RemoteEvent to communicate through.

&nbsp;

You COULD create the RemoteEvent as a static object in ReplicatedStorage, then write code on
both the server and the client to access that event and handle it as needed.

Of course, you have to hope the event is there when both the client and the server are looking for it.

You also have to do this for every RemoteEvent in your game...


*ugh*


Better way? PubSub.


PubSub creates RemoteEvents when they are needed and cleans them up when they aren't.


PubSub ensures RemoteEvents are always available prior to attempted use.


PubSub also supports client to client and server to server eventing. RemoteEvents (alone) do not.


___


Let's announce that new player in chat using PubSub:


`ServerScriptService > Script`

```
local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local PubSub = require(ReplicatedStorage:WaitForChild('PubSub'))

local OnPlayerConnected = function (player)
    PubSub.publish('AnnouncePlayer', player.Name)
end

Players.PlayerAdded:connect(OnPlayerConnected)
```


`Chat > ChatScript > ChatMain`

```
local StarterGui = game:GetService('StarterGui')
local PubSub = require(ReplicatedStorage:WaitForChild('PubSub'))

PubSub.subscribe('AnnouncePlayer', function (playerName)
	StarterGui:SetCore('ChatMakeSystemMessage', {
		Text = playerName..' joined the game!'
	})
end, 'ChatMain')
```


Done. That's all there is to it.


No RemoteEvent objects for you to create and it is easy to use, just Publish and Subscribe!


___


### To start using PubSub in your game:
+ Create a Module in ReplicatedStorage.
+ Rename the module to PubSub.
+ Copy source from the code here on GitHub in ReplicatedStorage\PubSub.lua
+ Paste the code into the PubSub module you made in your game and close the file.
+ Look in the GitHub ServerScriptService\BootStrap.lua to see more examples of use.


## THE FOLLOWING CODE FROM BOOTSTRAP.LUA IS REQUIRED IN YOUR SERVER CODE AS EARLY AS YOU CAN LOAD IT
If you leave this step out, the client and server will not talk to eachother!


If you are not sure what to do with this part, just copy the contents of BootStrap.lua
and paste them into a Script in ServerScriptService. Do your game init or start your game
at the end of the file after the following section has a chance to run.


```
local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local PubSub = require(ReplicatedStorage:WaitForChild('PubSub'))

local CreateRemoteEvent = PubSub:FindFirstChild('CreateRemoteEvent')

local onCreateRemoteEvent = function (player, t)
    return PubSub.createEvent(t)
end

CreateRemoteEvent.OnServerInvoke = onCreateRemoteEvent
```


On Roblox I'm HuotChu.


Check out my game, Big Idea, on Roblox!


If PubSub helps make your game awesome, consider buying a Coffee Reward game pass :)
#### https://www.roblox.com/games/798131599/
