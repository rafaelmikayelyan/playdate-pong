import 'CoreLibs/graphics'
-- import 'CoreLibs/crank'
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

local collisions = nil

local screenW <const> = PD.display.getWidth()
local screenH <const> = PD.display.getHeight()
local offset <const> = 10

local speed = 5
local moveX = speed
local moveY = 0

local turn = 0

local trueAngle = false

local function nextTurn()
		ball:moveTo(screenW / 2, screenH / 2)
		if turn % 2 == 1 then
			moveX = speed
		else
			moveX = -speed
		end
		moveY = 0
		turn += 1
end

local function checkBounds()
	if ball.y >= screenH or ball.y <= (0 + ball.r) then
		moveY = -moveY
	elseif ball.x >= screenW or ball.x <= 0 then
		score:add(ball.x)
		nextTurn()
	end
end

local function ricochet(mode)
	-- angle calculation
	if trueAngle then
		ratio = (ball.y - (paddle.y - paddleR) ) / paddleH
		angle = 160 * ratio * -moveX / math.abs(moveX)
		
		sinB = math.sin(math.rad(angle))
		cosB = math.cos(math.rad(angle))
		sinA = math.sin(math.rad(90-angle))
		moveX = speed * sinB
		moveY = moveX * sinA

	-- 2 angle zones
	else
		if ball.y - ball.r <= paddle.y and ball.y + ball.r >= paddle.y then
			print(ball.y)
			moveX = -moveX
			moveY = 0
		else
			moveX = -moveX
			if ball.y < paddle.y then
				moveY = -speed
			else
				moveY = speed
			end
		end
	end
end

local function updateBall()
	checkBounds()
	ball:moveBy(moveX, moveY)
end

local function initialize()
	player = Player(offset * 2, screenH / 2)
	paddle = Paddle(screenW - offset * 2, 110)
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
	collisions = ball:overlappingSprites()
	if #collisions > 0 then
		ricochet()
	end

	GFX.sprite.update()
	updateBall()

	GFX.drawTextAligned(score.p1..'* : *'..score.p2, screenW/2, offset, kTextAlignment.center)
end
