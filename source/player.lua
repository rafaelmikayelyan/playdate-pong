import 'paddle'

local PD <const> = playdate
local GFX <const> = PD.graphics

class('Player').extends(Paddle)

local TOP <const> = 8
local BOTTOM <const> = 228

function Player:init(x,y)
	Player.super.init(self, x, y)
end

function Player:update()
	-- Player.super.update(self)
	if PD.buttonIsPressed(PD.kButtonUp) then
		if self.y > TOP then
			self:moveBy(0, -self.speed)
		end
	elseif PD.buttonIsPressed(PD.kButtonDown) then
		if self.y < BOTTOM then
			self:moveBy(0, self.speed)
		end
	end
end
