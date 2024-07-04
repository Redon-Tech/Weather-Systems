if not plugin then
	local client = require(script.Parent.client)

	local success, result = pcall(function()
		return client:start()
	end)

	if not success then
		warn("[RTWS Client]: Client could not start\n", result, "\nTraceback:\n", debug.traceback())
	end
end
