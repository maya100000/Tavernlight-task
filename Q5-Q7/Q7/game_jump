
-- This module features a dynamic game window with a moving button labeled "Jump!". 
-- The button's Y-position randomizes when it hits the left edge of the window or 
-- when clicked.


-- Local variables for storing the window and button references
local jumpWindow = nil
local jumpBtn = nil
-- Event to make the button scroll
local clickEvent = nil 


-- Button movement increment in pixels
local scrollIncrement = 5 
-- The # of ms that pass between each movement
local scrollSpeed = 65 

-- Padding to ensure the button remains within bounds
local leftPadding = 15
local rightPadding = 60
local topBtmPadding = 20

function init()
    connect(g_game, {
        onGameStart = onLogin,
        onGameEnd = onLogout
    })
	-- Create the window using OTUI code and hide it
	jumpWindow = g_ui.displayUI('game_jump', modules.game_interface.getRightPanel())
	jumpWindow:hide()
	jumpBtn = jumpWindow:getChildById('jumpButton')
end

function terminate()
    disconnect(g_game, {
        onGameStart = onLogin,
        onGameEnd = onLogout
    })
	
	-- Destroy the window on exit
	jumpWindow:destroy()
end

function onLogin()
	-- Display the jump window upon login
	jumpWindow:show()
	btnReset()
	clickEvent = cycleEvent(btnMove, scrollSpeed)
end

-- Upon logout, cease button animation and reset the window
function onLogout()

	removeEvent(clickEvent)
	jumpReset()
end

-- Resets the button position to the right edge of the window
-- with a random Y-position
function btnReset()
    local position = jumpWindow:getPosition()
	-- Set X-position with padding to prevent it from leaving the window
    position.x = position.x + jumpWindow:getWidth() - rightPadding
	-- Randomize Y-position within the height bounds of the window
	position.y = position.y + math.random(topBtmPadding, (jumpWindow:getHeight() - topBtmPadding))
	jumpBtn:setPosition(position)
end

-- Initiates button scrolling from right to left
function btnMove()
	local position = jumpBtn:getPosition()
	position.x = position.x - scrollIncrement
	
	if position.x < jumpWindow:getPosition().x + leftPadding then
		btnReset()
	else
		jumpBtn:setPosition(position)
	end
end

-- Hides the window and halts the animation
function jumpReset()
	jumpWindow:hide()
	
	if clickEvent then
		removeEvent(clickEvent)
	end
end
