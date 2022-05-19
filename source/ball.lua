local PD <const> = playdate
local GFX <const> = PD.graphics

class('Ball').extends(GFX.sprite)

local r <const> = 4

function Ball:init(x, y)
	-- not necessary
	Ball.super.init(self)

	self.x = x
	self.y = y
	self.r = r

	self:moveTo(x, y)

	local img = GFX.image.new(r * 2, r * 2)
	GFX.pushContext(img)
	GFX.fillRect(0, 0, r * 2, r * 2)
	GFX.popContext()
	self:setImage(img)

	self:setCollideRect(0, 0, self:getSize())
	
	self:add()
end
