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

	loadRecord()
	createScore(true)

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

	-- set menu background
	local imgMenu = GFX.image.new('images/menu')
	assert(imgMenu)

	-- add menu scoreboard
	if getRecord() then
		GFX.pushContext(imgMenu)
		GFX.drawText('Last longest game: '..getRecord(), 10, 215)
		GFX.popContext()
	end
	PD.setMenuImage(imgMenu, 0)
end

initialize()

local function restart()
	GFX.sprite.removeAll()

	initialize()
end

function playdate.update()
	GFX.sprite.update()
	
	checkGameOver()
end

-- menu
local menu = playdate.getSystemMenu()

local menuItem, error = menu:addMenuItem("restart", function()
    restart()
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