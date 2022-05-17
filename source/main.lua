import 'CoreLibs/graphics'
import 'CoreLibs/crank'
-- import 'CoreLibs/object'
import 'CoreLibs/sprites'
-- import 'CoreLibs/timer'

local pd <const> = playdate
local gfx <const> = pd.graphics

local paddle = nil
local paddlePC = nil
local ball = nil
local collisions = nil
local angle = nil

local screenW = 400
local screenH = 240
local offset = 10
local ballR = 4
local paddleR = 18
local paddleH = paddleR * 2
local paddleS = 4

local paddleSpeed = 5
local speed = 4
local default = speed

local ballW = 8
local ballX = 5
local ballY = 5

local scorePlayer = 0
local scorePC = 0

local function updateScore(i)
	if i > 0 then
		scorePlayer += 1
	elseif i < 0 then
		scorePC += 1
	else
		scorePlayer = 0
		scorePC = 0
	end
end

local function centerBall()
	ball:moveTo(screenW / 2, screenH / 2)
end

local function checkBounds()
	if ball.y >= screenH or ball.y <= (0 + ballR) then
		ballY = -ballY
	elseif ball.x >= screenW or ball.x <= 0 then
		updateScore(ball.x)
		ball:moveTo(screenW / 2, screenH / 2)
		ballX = -speed
		ballY = 0
	end
end

local function reflect()
	ratio = (ball.y - paddle.y) / paddleR
	-- angle = 80 * ratio
	angle = 10
	sinB = math.sin(math.rad(angle))
	ballX = speed * sinB
	ballY = ballX * math.cos(math.rad(angle))
	speed = -speed
	print('----------------')
	print('angle '..angle.. ' speed '..speed)
	print('sin '..sinB)

end

local function updateBall()
	checkBounds()
	ball:moveBy(ballX, ballY)
end

local function initialize()
	local imgP = gfx.image.new('images/paddle-m')
	assert(imgP)
	paddle = gfx.sprite.new(imgP)
	paddle:moveTo(offset * 2, screenH / 2)
	paddle:setCollideRect(0, 0, paddle:getSize())
	paddle:add()

	paddlePC = gfx.sprite.new(imgP)
	paddlePC:moveTo(screenW - offset, screenH / 2)
	paddlePC:setCollideRect(0, 0, paddlePC:getSize())
	paddlePC:add()
	
	local imgB = gfx.image.new('images/ball')
	assert(imgB)
	ball = gfx.sprite.new(imgB)
	centerBall()
	ball:setCollideRect(0, 0, ball:getSize())
	ball:add()

	local imgBG = gfx.image.new('images/background')
	assert(imgBG)
	gfx.sprite.setBackgroundDrawingCallback(
		function(x, y, w, h)
			gfx.setClipRect(x, y, w, h)
			imgBG:draw(0, 0)
			gfx.clearClipRect()
		end
	)
end

initialize()

function playdate.update()
	if pd.buttonIsPressed(pd.kButtonUp) then
		if paddle.y > paddleH then
			paddle:moveBy(0, -paddleSpeed)
			paddlePC:moveBy(0, -paddleSpeed)
		end
	end
	if pd.buttonIsPressed(pd.kButtonDown) then
		if paddle.y < screenH - paddleH then
			paddle:moveBy(0, paddleSpeed)
			paddlePC:moveBy(0, paddleSpeed)
		end
	end

	collisions = ball:overlappingSprites()
	if #collisions > 0 then
		reflect()
	end

	gfx.sprite.update()

	updateBall()

	gfx.drawTextAligned(scorePlayer .. '* : *' .. scorePC, screenW/2, offset, kTextAlignment.center)
	gfx.drawTextAligned(ball.x .. ' , ' .. ball.y, screenW/2, screenH - 30, kTextAlignment.center)
end
