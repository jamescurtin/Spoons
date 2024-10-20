--- === CameraStatus ===
---
--- Trigger webhooks to enable or disable a status light/monitor/etc. based on
--- the computer's camera state.
---
--- Example (assumes you are using `SpoonInstall` to load spoons):
---
--- ```
--- -- This plugin requires two webhook URLs (e.g. from HomeAssistant) that will
--- -- be triggered based on the computer's camera state.
---
--- local statusONwebhook = "https://some-webhook.url/on"
--- local statusOFFwebhook = "https://some-webhook.url/off"
---
--- hs.loadSpoon("SpoonInstall")
--- SpoonInstall = spoon.SpoonInstall
--- SpoonInstall.repos = {
---     default = {
---         url = "https://github.com/Hammerspoon/Spoons",
---         desc = "Main Hammerspoon Spoon repository",
---         branch = "master",
---     },
---     jamescurtin = {
---         url = "https://github.com/jamescurtin/Spoons",
---         desc = "James Curtin's Spoons",
---         branch = "master",
---     },
--- }
---
--- SpoonInstaller:andUse("CameraStatus",
---   {
---       repo = "jamescurtin",
---       start = true,
---       config = {
---           cameraOnHook = statusONwebhook,
---           cameraOffHook = statusOFFwebhook,
---       }
---   }
--- )
--- ```

-----------------------
-- Setup Environment --
-----------------------

local obj = {}
obj.__index = obj

-- Spoon metadata
obj.name = "CameraStatus"
obj.version = "0.1"
obj.author = "James Curtin <jameswcurtin@gmail.com>"
obj.license = "MIT"
obj.homepage = "https://github.com/jamescurtin/Spoons"

---------------
-- Variables --
---------------

--- CameraStatus.cameraOnHook (String)
--- Variable
--- A webhook URL that will be used to trigger an event when an attached camera is turned on.
obj.cameraOnHook = nil

--- CameraStatus.cameraOffHook (String)
--- Variable
--- A webhook URL that will be used to trigger an event when an attached camera is turned off.
obj.cameraOffHook = nil

-------------
-- Private --
-------------

local function isempty(s)
	return s == nil or s == ""
end

local function stopConfigureAndStartPropertyWatcher(camera)
	if camera:isPropertyWatcherRunning() then
		camera:stopPropertyWatcher()
	end

	camera:setPropertyWatcherCallback(function(_, _, _, _)
		obj:checkCameraStatus()
	end)
	camera:startPropertyWatcher()
end

------------
-- Public --
------------

--- CameraStatus:checkCameraStatus() -> Self
--- Method
--- Makes a one-time call to check camera state.
---
--- Parameters:
---  * None
---
--- Returns:
---  * Self
---
--- Notes:
--- Makes an empty POST request to the "cameraOnHook" webhook if any camera is enabled.
--- Makes an empty POST request to the "cameraOffHook" webhook if no camera is enabled.
function obj:checkCameraStatus()
	local anyCameraInUse = false
	for _, camera in pairs(hs.camera.allCameras()) do
		if camera:isInUse() then
			anyCameraInUse = true
			break
		end
	end

	if anyCameraInUse then
		hs.http.post(self.cameraOnHook, nil, nil)
	else
		hs.http.post(self.cameraOffHook, nil, nil)
	end
	return self
end

--- CameraStatus:start() -> Self
--- Method
--- Enables the CameraStatus spoon.
---
--- Parameters:
---  * None
---
--- Returns:
---  * Self
---
--- Notes:
--- The spoon uses a camera watcher to poll for camera status.
--- Additionally, it will register cameras that are added after the spoon has
--- been initialized.
--- Calls the "On" webhook if any camera is enabled.
--- Calls the "Off" webhook if no camera is enabled.
function obj:start()
	if isempty(self.cameraOnHook) or isempty(self.cameraOffHook) then
		hs.alert("CameraStatus could not be configured.")
	end

	for _, camera in pairs(hs.camera.allCameras()) do
		stopConfigureAndStartPropertyWatcher(camera)
	end

	hs.camera.setWatcherCallback(function(camera, state)
		if state == "Added" then
			stopConfigureAndStartPropertyWatcher(camera)
		end
		self:checkCameraStatus()
	end)
	hs.camera.startWatcher()

	-- check camera status on startup to make sure they are on
	self:checkCameraStatus()
	return self
end

return obj
