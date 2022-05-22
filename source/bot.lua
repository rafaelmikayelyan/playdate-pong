import 'paddle'

local PD <const> = playdate
local GFX <const> = PD.graphics

class('Bot').extends(Paddle)

local TOP <const> = 12
local BOTTOM <const> = 228

local ball

local reactionDistance <const> = PD.display.getWidth() - 100

function Bot:init(x,y)
	Bot.super.init(self, x, y)
	self.speed = self.speed
end

local function catch(self, x, y)
	if reactionDistance < x then
		if self.y < BOTTOM and self.y < y then
			self:moveBy(0, self.speed)
		elseif self.y > TOP and self.y > y then
			self:moveBy(0, -self.speed)
		end
	end
end

local function getKata(self)
	if self.y < 110 then
		self:moveBy(0, self.speed)
	elseif self.y > 130 then
		self:moveBy(0, -self.speed)
	end
end

local function response(self, ball)
	if ball[3] ~= nil then
		if ball[3] < 0 then
			catch(self, ball[1], ball[2])
		else
			getKata(self)
		end
	end

end

function Bot:update()
	response(self, getBallStatus())
end