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
local score = nil

local screenW <const> = PD.display.getWidth()
local screenH <const> = PD.display.getHeight()
local offset <const> = 10

local function initialize()
	player = Player(offset * 2, screenH / 2)
	paddle = Paddle(screenW - offset * 2, screenH / 2)
	ball = Ball(screenW / 2, screenH / 2)
	score = Score(20, 20, 0, 0)

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

	-- GFX.drawTextAligned(score.p1..'* : *'..score.p2, screenW/2, offset, kTextAlignment.center)
end
