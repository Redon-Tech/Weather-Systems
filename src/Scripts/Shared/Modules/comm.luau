-- Redon Tech Weather System

export type remoteEvent = {
	remote: RemoteEvent,
	connect: (any, func: (...any) -> ...any) -> RBXScriptConnection,
	fire: (Player, ...any) -> (),
}

export type remoteEventServer = remoteEvent & {
	fireAll: (...any) -> (),
	fireFilter: ((Player, ...any) -> boolean, ...any) -> (),
	fireFor: ({ Player }, ...any) -> (),
}

export type bindableEvent = {
	event: BindableEvent,
	connect: (any, func: (...any) -> ...any) -> RBXScriptConnection,
	fire: (...any) -> (),
}

export type commImpl = {
	__index: commImpl,

	new: (namespace: string) -> comm,
	setup: () -> (),

	folderCheck: (self: comm) -> boolean,
	remoteFunction: (
		self: comm,
		name: string,
		bindTo: { [any]: any } | (...any) -> ...any,
		funcName: string?
	) -> RemoteFunction,
	invokeFunction: (self: comm, name: string, ...any) -> ...any,
	remoteEvent: (self: comm, name: string, ...any) -> (remoteEvent | remoteEventServer)?,
	bindableFunction: (
		self: comm,
		name: string,
		bindTo: {} | (...any) -> ...any,
		funcName: string
	) -> BindableFunction?,
	bindableEvent: (self: comm, name: string, ...any) -> bindableEvent?,
}

export type comm = typeof(setmetatable(
	{} :: {
		_commFolder: Folder,
		folder: Folder,
		namespace: string,
	},
	{} :: commImpl
))

local comm = {} :: commImpl
comm.__index = comm

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local wsShared = ReplicatedStorage:WaitForChild("WeatherSystem_Shared")

local configuration = wsShared:WaitForChild("Configuration")
local isServer = RunService:IsServer()

local isDebug = configuration:GetAttribute("debug")
local print = function(...)
	if isDebug then
		print(`[RTWS {if isServer then "Server" else "Client"}]: `, ...)
	end
end
local warn = function(...)
	if isDebug then
		warn(`[RTWS {if isServer then "Server" else "Client"}]: `, ...)
	end
end

function comm.new(namespace: string): comm
	print(`Initializing Comm {namespace}`)
	local data = {
		_commFolder = wsShared:WaitForChild("commEvents"),
		namespace = namespace,
	}
	local self = setmetatable(data, comm)

	if isServer == true then
		self.folder = self._commFolder:FindFirstChild(namespace)
		if self.folder == nil then
			self.folder = Instance.new("Folder")
			self.folder.Name = namespace
			self.folder.Parent = self._commFolder
		end
	else
		self.folder = self._commFolder:WaitForChild(namespace)
	end

	print(`Initialized Comm {namespace}`)

	return self
end

function comm.setup()
	if isServer == false then
		warn("setup can't be run on client")
		return
	end
	print("Comm Setup Started")
	if ReplicatedStorage:FindFirstChild("comm") then
		warn("Attempted to setup after setup has already happened")
		return
	end

	local commFolder = Instance.new("Folder")
	commFolder.Name = "commEvents"
	commFolder.Parent = wsShared
	print("Comm Setup Complete")
end

function comm.folderCheck(self: comm): boolean
	if self.folder == nil then
		warn(`{self.namespace} has no folder`)
		return false
	end
	return true
end

function comm.remoteFunction(
	self: comm,
	name: string,
	bindTo: { [any]: any } | (...any) -> ...any,
	funcName: string?
): RemoteFunction?
	if self:folderCheck() == false then
		return
	end

	if isServer == true then
		if self.folder:FindFirstChild(name) then
			warn(`RemoteFunction {name} already exists.`)
			return
		end

		local remote = Instance.new("RemoteFunction")
		remote.Name = name
		remote.Parent = self.folder

		if typeof(bindTo) == "table" then
			remote.OnServerInvoke = function(...)
				return bindTo[funcName](bindTo, ...) -- the first param is bindTo to pass back in self :D
			end
		else
			remote.OnServerInvoke = bindTo
		end
		return remote
	end

	return
end

function comm.invokeFunction(self: comm, name: string, ...): ...any
	if self:folderCheck() == false then
		return
	end

	if isServer == false then
		local remote = self.folder:WaitForChild(name)
		return remote:InvokeServer(...)
	end

	return
end

function comm.remoteEvent(self: comm, name: string, ...): (remoteEvent | remoteEventServer)?
	if self:folderCheck() == false then
		return
	end

	if isServer == true then
		local remoteEvent = {} :: remoteEventServer
		remoteEvent.__index = remoteEvent

		remoteEvent.remote = self.folder:FindFirstChild(name) or Instance.new("RemoteEvent")
		remoteEvent.remote.Name = name
		remoteEvent.remote.Parent = self.folder

		function remoteEvent:connect(func: (...any) -> ...any): RBXScriptConnection
			return self.remote.OnServerEvent:Connect(func)
		end

		function remoteEvent:fireAll(...)
			self.remote:FireAllClients(...)
		end

		function remoteEvent:fire(player: Player, ...)
			self.remote:FireClient(player, ...)
		end

		function remoteEvent:fireFilter(filter: (Player, ...any) -> boolean, ...)
			for _, player: Player in pairs(Players:GetPlayers()) do
				if filter(player, ...) then
					self:fire(player, ...)
				end
			end
		end

		function remoteEvent:fireFor(players: { Player }, ...)
			for _, player: Player in pairs(players) do
				self:fire(player, ...)
			end
		end

		return remoteEvent
	else
		local remoteEvent = {} :: remoteEvent
		remoteEvent.__index = remoteEvent

		remoteEvent.remote = self.folder:WaitForChild(name)

		function remoteEvent:connect(func: (...any) -> ...any): RBXScriptConnection
			return self.remote.OnClientEvent:Connect(func)
		end

		function remoteEvent:fire(...)
			self.remote:FireServer(...)
		end

		return remoteEvent
	end
end

function comm.bindableFunction(
	self: comm,
	name: string,
	bindTo: {} | (...any) -> ...any,
	funcName: string
): BindableFunction?
	if self:folderCheck() == false then
		return
	end

	if self.folder:FindFirstChild(name) then
		warn(`BindableFunction {name} already exists.`)
		return
	end

	local bindableFunction = Instance.new("BindableFunction")
	bindableFunction.Name = name
	bindableFunction.Parent = self.folder

	if typeof(bindTo) == "table" then
		bindableFunction.OnInvoke = function(...)
			return bindTo[funcName](bindTo, ...) -- the first param is bindTo to pass back in self :D
		end
	else
		bindableFunction.OnInvoke = bindTo
	end
	return bindableFunction
end

function comm.bindableEvent(self: comm, name: string, ...): bindableEvent?
	if self:folderCheck() == false then
		return
	end

	local bindableEvent = {}
	bindableEvent.__index = bindableEvent

	bindableEvent.event = self.folder:FindFirstChild(name) or Instance.new("BindableEvent")
	bindableEvent.event.Name = name
	bindableEvent.event.Parent = self.folder

	function bindableEvent:connect(func: (...any) -> ...any): RBXScriptConnection
		return self.remote.Event:Connect(func)
	end

	function bindableEvent:fire(...)
		self.remote:Fire(...)
	end

	return bindableEvent
end

return comm
