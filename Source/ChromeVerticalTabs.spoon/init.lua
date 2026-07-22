--- === ChromeVerticalTabs ===
---
--- Toggle Chrome's vertical tabs sidebar with a keyboard shortcut.
--- Uses the macOS accessibility API to find and press the Expand/Collapse
--- tabs button in Chrome's UI.
---
--- Example:
---
--- ```
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
--- SpoonInstaller:andUse("ChromeVerticalTabs",
---   {
---       repo = "jamescurtin",
---       start = true,
---       config = {
---           hotkey = {{"cmd", "ctrl"}, "s"},
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
obj.name = "ChromeVerticalTabs"
obj.version = "0.1"
obj.author = "James Curtin <jameswcurtin@gmail.com>"
obj.license = "MIT"
obj.homepage = "https://github.com/jamescurtin/Spoons"

---------------
-- Variables --
---------------

--- ChromeVerticalTabs.hotkey (Table)
--- Variable
--- A table containing the hotkey modifiers and key to bind.
--- Default is {{"cmd", "ctrl"}, "s"}.
obj.hotkey = {{"cmd", "ctrl"}, "s"}

-------------
-- Private --
-------------

local function findButton(el, depth)
	if depth > 10 then return nil end
	local role = el:attributeValue("AXRole") or ""
	local title = el:attributeValue("AXTitle") or ""
	local desc = el:attributeValue("AXDescription") or ""
	local targets = {
		["Expand tabs"] = true, ["Collapse tabs"] = true,
		["Expand Tabs"] = true, ["Collapse Tabs"] = true,
	}
	if role == "AXButton" and (targets[title] or targets[desc]) then
		return el
	end
	for _, child in ipairs(el:attributeValue("AXChildren") or {}) do
		local found = findButton(child, depth + 1)
		if found then return found end
	end
	return nil
end

local function toggleSidebar()
	local chrome = hs.application.get("com.google.Chrome")
	if not chrome then
		hs.alert.show("Chrome not running")
		return
	end

	local win = chrome:mainWindow()
	if not win then
		hs.alert.show("No Chrome window")
		return
	end

	local axWin = hs.axuielement.windowElement(win)
	local btn = findButton(axWin, 0)
	if btn then
		btn:performAction("AXPress")
	else
		hs.alert.show("Sidebar button not found")
	end
end

------------
-- Public --
------------

--- ChromeVerticalTabs:toggle() -> Self
--- Method
--- Toggles Chrome's vertical tabs sidebar.
---
--- Parameters:
---  * None
---
--- Returns:
---  * Self
---
--- Notes:
--- Finds the Expand/Collapse tabs button in Chrome's accessibility tree and presses it.
--- Shows an alert if Chrome is not running or the button cannot be found.
function obj:toggle()
	toggleSidebar()
	return self
end

--- ChromeVerticalTabs:start() -> Self
--- Method
--- Binds the hotkey to toggle Chrome's vertical tabs sidebar.
---
--- Parameters:
---  * None
---
--- Returns:
---  * Self
function obj:start()
	local mods = self.hotkey[1]
	local key = self.hotkey[2]
	self._hotkey = hs.hotkey.bind(mods, key, toggleSidebar)
	return self
end

--- ChromeVerticalTabs:stop() -> Self
--- Method
--- Unbinds the hotkey.
---
--- Parameters:
---  * None
---
--- Returns:
---  * Self
function obj:stop()
	if self._hotkey then
		self._hotkey:delete()
		self._hotkey = nil
	end
	return self
end

return obj
