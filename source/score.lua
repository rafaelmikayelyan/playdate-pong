local PD <const> = playdate
local GFX <const> = PD.graphics

class('Score').extends()

local p1 = 0
local p2 = 0

function Score:init(x, y, p1, p2)
	self.p1 = p1
	self.p2 = p2
end

function Score:add(p)
	if p > 0 then
		self.p1 += 1
	else
		self.p2 += 1
	end
	self:update()
	print(self.p1..' : '..self.p2)
end

function Score:update()
	print('update')
end

function Score:win()
	print('win')
end
