import 'CoreLibs/graphics'
import 'CoreLibs/crank'
import 'CoreLibs/object'
import 'CoreLibs/sprites'
-- import 'CoreLibs/timer'

import 'paddle'
import 'player'
import 'ball'
import 'score'

local PD <const> = playdate
local GFX <const> = PD.graphics

local player = nil
local bot = nil
local ball = nil

local screenDimensions <const> = {x = PD.display.getWidth(), y = PD.display.getHeight()}
local offset <const> = 10

local function initialize()
	player = Player(offset * 2, screenDimensions.y / 2)
	paddle = Paddle(screenDimensions.x - offset * 2, screenDimensions.y / 2)
	ball = Ball(screenDimensions.x / 2, screenDimensions.y / 2)

	createScore()

	-- background
	local imgBG = GFX.image.new('images/background')
	assert(imgBG)
	GFX.sprite.setBackgroundDrawingCallback(
		function(x, y, w, h)
			GFX.setClipRect(x, y, w, h)
			imgBG:draw(0, 0)
			GFX.clearClipRect()
		end
	)

	-- menu background
	local imgMenu = GFX.image.new('images/menu')
	assert(imgMenu)
	PD.setMenuImage(imgMenu, 0)
end

initialize()

function playdate.update()
	GFX.sprite.update()
	
	checkGameOver()
end

--First determine which option should already be selected when the menu opens ("storedValue" is assumed to be some variable--which need not be an integer--that exists in your game already):

-- local preSelectedMenuOption
-- if storedValue == 1 then --Whatever value was set previously by your game (maybe an initial default, maybe a prior hoice saved in playdate.datastore)
-- 	preSelectedMenuOption = "option A"
-- elseif storedValue == 2 then
-- 	preSelectedMenuOption = "option B"
-- else
-- 	preSelectedMenuOption = "option C"
-- end

-- --Then create the menu item (its title will be forced to lowercase by the system, but capitalization of its options is in your control):

-- local menu = playdate.getSystemMenu()

-- local menuItem, error = menu:addOptionsMenuItem("title", {"option A", "option B", "option C"}, preSelectedMenuOption, function(value)
-- 	setstoredValue(value)
-- end)

-- --This function runs when the system menu closes, if the user changed the option:

-- function setstoredValue(value)
-- 	if value == "option A" then
-- 		storedValue = 1
-- 	elseif value == "option B" then
-- 		storedValue = 2
-- 	else
-- 		storedValue = 3
-- 	end
	
-- 	--Take actions here to make use of the new "storedValue" (and save it to playdate.datastore for future sessions if desired)
-- end

local menu = playdate.getSystemMenu()

local menuItem, error = menu:addMenuItem("restart", function()
    print("restart")
end)

local checkmarkMenuItem, error = menu:addCheckmarkMenuItem("true-angle", true, function(value)
	setMutiAngle(value)
end)

local checkmarkMenuItem, error = menu:addCheckmarkMenuItem("speedball", false, function(value)
	if value then
		setSpeed(16)
	else
		setSpeed(8)
	end
end)