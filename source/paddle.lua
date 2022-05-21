local PD <const> = playdate
local GFX <const> = PD.graphics

class('Paddle').extends(GFX.sprite)

local r <const>	= 12

function Paddle:init(x, y)
	self:moveTo(x,y)

	self.x = x
	self.y = y
	self.speed = r / 2
	self.r = r

	local img = GFX.image.new(8, r * 2)
	GFX.pushContext(img)
	GFX.fillRect(0, 0, 8, r * 2)
	GFX.popContext()
	self:setImage(img)

	self:setCollideRect(0, 0, self:getSize())

	self:add()
end
