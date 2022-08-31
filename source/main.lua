import 'CoreLibs/graphics'
import 'CoreLibs/crank'
import 'CoreLibs/object'
import 'CoreLibs/sprites'
-- import 'CoreLibs/timer'

import 'bot'
import 'player'
import 'ball'
import 'score'

local PD <const> = playdate
local GFX <const> = PD.graphics

local version <const> =  'v: '..PD.metadata.version

local player = nil
local bot = nil
local ball = nil

local screenDimensions <const> = {x = PD.display.getWidth(), y = PD.display.getHeight()}
local offset <const> = 10

local function setBackground()
	local imgBG = GFX.image.new('images/background')
	assert(imgBG)
	GFX.sprite.setBackgroundDrawingCallback(
		function(x, y, w, h)
			GFX.setClipRect(x, y, w, h)
			imgBG:draw(0, 0)
			GFX.clearClipRect()
		end
	)
end

local function setMenu()
	-- set menu background
	local imgMenu = GFX.image.new('images/menu')
	assert(imgMenu)

	-- add menu scoreboard
	if getRecord() then
		GFX.pushContext(imgMenu)
		GFX.drawText('*Longest game: '..getRecord()..'*', 10, 215)
		GFX.drawText(version, 155, 215)
		GFX.popContext()
	end
	PD.setMenuImage(imgMenu, 0)
end

local function initialize()
	player = Player(offset * 2, screenDimensions.y / 2)
	bot = Bot(screenDimensions.x - offset * 2, screenDimensions.y / 2)
	ball = Ball(screenDimensions.x / 2, screenDimensions.y / 2)

	loadRecord()
	createScore(true)

	setBackground()
	setMenu()
end

initialize()

local function restart()
	GFX.sprite.removeAll()

	initialize()
end

function PD.update()
	GFX.sprite.update()

	if PD.buttonIsPressed(PD.kButtonA) then
		print('a')
	end
	if PD.buttonIsPressed(PD.kButtonB) then
		print('b')
	end
	
	checkGameOver()
end

-- menu
local menu = PD.getSystemMenu()

local menuItem, error = menu:addMenuItem("restart", function()
    restart()
end)

local checkmarkMenuItem, error = menu:addCheckmarkMenuItem("true-angle", true, function(value)
	setMutiAngle(value)
end)

local checkmarkMenuItem, error = menu:addCheckmarkMenuItem("fastball", false, function(value)
	setSpeedball(value)
end)
