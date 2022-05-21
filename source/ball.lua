local PD <const> = playdate
local GFX <const> = PD.graphics

class('Ball').extends(GFX.sprite)

local r <const> = 4
local screenCenter <const> = {x = PD.display.getWidth() / 2, y = PD.display.getHeight() / 2}

local direction

local speed = 8
local multiAngle = true

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
	self:moveTo(screenCenter.x, screenCenter.y)
	self.vector.x = speed * getTurn().turn
	self.vector.y = 0
end

local function ricochet(self, paddle)
	direction = self.vector.x / math.abs(self.vector.x)

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
		self.vector.y = speed * sinA * direction

		-- print('Vxy: '..self.vector.x..' '..self.vector.y..'\t\tangle: '..angle..'\tspeed: '..math.sqrt(self.vector.x^2 + self.vector.y^2)..'\tsinB cosB: '..sinB..' '..cosB)

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
	if length > 0 then
		for index, collision in pairs(collisions) do
			local collidedObject = collision['other']
			if collidedObject:isa(Player) or collidedObject:isa(Paddle) then
				ricochet(self, collidedObject)
			end
		end
	elseif actualX < 0 or actualX > 400 then
		resetBall(self)
		addScore(actualX)	
	elseif actualY < 0 + self.r or actualY > 240 - self.r then
		self.vector.y = -self.vector.y
	end
end

function Ball:collisionResponse()
    return 'bounce'
end

function setMutiAngle(bool)
	multiAngle = bool
end

function setSpeed(int)
	speed = int
end