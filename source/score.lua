local PD <const> = playdate
local GFX <const> = PD.graphics

local scoreSprite

local p1 = 0
local p2 = 0
local turn
local total
local winCondition = 10
local longestGame = 0
local notSaved = true

function createScore(isNewGame)
	if isNewGame then
		p1 = 0
		p2 = 0
		notSaved = true
	end

	scoreSprite = GFX.sprite.new()
	updateScore()
	scoreSprite:setCenter(0.5, 0.5)
	scoreSprite:moveTo(200, 20)
	scoreSprite:add()
end

function updateScore()
	local scoreText = p1..' : '..p2
	local textWidth, textHeight = GFX.getTextSize(scoreText)
	local scoreImg = GFX.image.new(textWidth, textHeight)
	GFX.pushContext(scoreImg)
	GFX.drawText(scoreText, 0, 0)
	GFX.popContext()
	scoreSprite:setImage(scoreImg)
end

function addScore(p)
	if p > 0 then
		p1 += 1
	else
		p2 += 1
	end
	updateScore()
end

function resetScore()
	p1 = 0
	p2 = 0
	updateScore()
end

function getTurn()
	total = p1 + p2
	turn = total % 2
	if turn == 0 then
		turn = -1
	end
	return {turn = turn, total = total}
end

function getScore()
	return {p1 = p1, p2 = p2}
end

function getRecord()
	return longestGame
end

local function saveRecord()
	notSaved = false
	total += 1
	if total > longestGame then
		longestGame = total
	end
	print(longestGame)
end

function checkGameOver()
	local difference = p1 - p2
	if math.abs(difference) >= winCondition then
		local endText

		GFX.sprite.removeAll()
		
		if difference > 0 then
			endText = 'WON!'
		else
			endText = 'LOST!'
		end

		local endSprite = GFX.sprite.new()
		endSprite:setCenter(0.5, 0.5)
		endSprite:moveTo(200, 110)
		endSprite:add()
		local textWidth, textHeight = GFX.getTextSize(endText)
		local endImg = GFX.image.new(textWidth, textHeight)
		GFX.pushContext(endImg)
		GFX.drawText(endText, 0, 0)
		GFX.popContext()
		endSprite:setImage(endImg)
		
		if notSaved then
			saveRecord()
		end
		createScore()
		scoreSprite:moveTo(200, 130)
	end
end
