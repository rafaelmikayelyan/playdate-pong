local PD <const> = playdate
local GFX <const> = PD.graphics

import 'sound'

class('Ball').extends(GFX.sprite)

local r <const> = 4
local screenCenter <const> = {x = PD.display.getWidth() / 2, y = PD.display.getHeight() / 2}

local direction

local speed = 8
local maxSpeed <const> = 20
local acceleration <const> = 1
local multiAngle = true
local speedball = false

local ballStatus = {0, 0, -1}

function Ball:init(x, y)
	-- not necessary
	Ball.super.init(self)

	self.x = x
	self.y = y
	self.r = r
	self.vector = {x = speed, y = 0}

	self:moveTo(x, y)

	local img = GFX.image.new(r * 2, r * 2)
	GFX.pushContext(img)
	GFX.fillRect(0, 0, r * 2, r * 2)
	GFX.popContext()
	self:setImage(img)

	self:setCollideRect(0, 0, self:getSize())
	
	self:add()
end

local function resetBall(self)
	if speedball then
		speed = maxSpeed
	else
		speed = 8
	end
	self:moveTo(screenCenter.x, screenCenter.y)
	self.vector.x = speed * getTurn().turn
	self.vector.y = 0
	ballStatus = {0, 0, -1}
end

local function ricochet(self, paddle)
	direction = self.vector.x / math.abs(self.vector.x)
	getCollideSound(1)

	-- calculate the angle
	if multiAngle then
		ratio = (self.y - (paddle.y - paddle.r)) / (2 * paddle.r)
		if ratio < 0.1 then
			ratio = 0.1
		elseif ratio > 0.9 then
			ratio = 0.9
		end

		angle = 180 * ratio
		
		sinB = math.sin(math.rad(angle))
		cosB = math.cos(math.rad(angle))
		sinA = math.sin(math.rad(90-angle))
		self.vector.x = speed * sinB * -direction
		self.vector.y = speed * sinA * direction * self.vector.x / math.abs(self.vector.x)

	-- simple 2-angle
	else
		if self.y - self.r <= paddle.y and self.y + self.r >= paddle.y then
			self.vector.x = speed * -direction
			self.vector.y = 0
		else
			if self.y < paddle.y - paddle.r or self.y > paddle.y + paddle.r then
				self.vector.x = speed * direction
			else
				self.vector.x = speed * -direction
			end
			if self.y < paddle.y then
				self.vector.y = -speed / 2
			else
				self.vector.y = speed / 2
			end
		end
	end
end

function Ball:update()
	local actualX, actualY, collisions, length = self:moveWithCollisions(self.x + self.vector.x, self.y + self.vector.y)
	local correction = 0

	if length > 0 then
		for index, collision in pairs(collisions) do
			local collidedObject = collision['other']
			if collidedObject:isa(Player) or collidedObject:isa(Bot) then
				ricochet(self, collidedObject)
				if speed < maxSpeed then
					speed += acceleration
				end
			end
		end
	elseif actualX < 0 or actualX > 400 then
		getCollideSound(-1)
		resetBall(self)
		addScore(actualX)	
	elseif actualY < 0 + self.r or actualY > 240 - self.r then
		getCollideSound(0)
		self.vector.y = -self.vector.y
	end

	ballStatus = {self.x, self.y, direction}
end

function Ball:collisionResponse()
    return 'bounce'
end

function setMutiAngle(bool)
	multiAngle = bool
end

function setSpeedball(bool)
	speedball = bool
end

function getBallStatus()
	return ballStatus
end
