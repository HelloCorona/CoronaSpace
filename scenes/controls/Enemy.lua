local GameConfig = require("GameConfig")
local physics = require("physics")
local EnterFrameManager = require("managers.EnterFrameManager")

local Class = {}

Class.create = function (_parent)
	-- 적기의 스킨 타입 (0 ~ 3)
	local enemyType = math.random(0, GameConfig.gameLevel)

	-- 적기의 이동 속력
	local _skinType = GameConfig.getPlayerSkinType() -- 0 ~ 2
	local enemySpeed = enemyType + 1.2 + (_skinType / 4)

	-- 적기 생성
	local enemy = display.newImage(_parent, "images/enemy_0"..enemyType..".png", 0, 0)
	__setScaleFactor(enemy, 0.7)
	enemy.type = enemyType
	physics.addBody(enemy, "kinematic", {friction=1, filter={categoryBits=2, maskBits=1}})

		-- 이동
	local on_EnterFrame = EnterFrameManager.addListener(function (e)
		enemy.x = enemy.x - enemySpeed
		if enemy.x < -enemy.width then
			-- 침입 이벤트 발생, 생명 줄어듬
			local evt = {name="invaded"}
			enemy:dispatchEvent(evt)

			enemy.destroy()
		end
	end)

	--===================================
	--
	-- Public Methods
	--
	--===================================

	-- 적기 제거
	enemy.destroy = function ()
		EnterFrameManager.removeListener(on_EnterFrame)
		enemy:removeSelf()
	end

	return enemy
end

return Class