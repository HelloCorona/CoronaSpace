local physics = require("physics")
local EnterFrameManager = require("managers.EnterFrameManager")

local Class = {}

Class.create = function (_parent, skinPath, direction, bulletSpeed)
		-- 총알 생성 (화면 밖으로 나가는 계산을 간편하게 하기 위해 좌상단을 기준점으로 함)
	local bullet = display.newImage(_parent, "images/"..skinPath, 0, 0)
	__setScaleFactor(bullet, 0.7)
	physics.addBody(bullet, "dynamic", {friction=1, filter={categoryBits=1, maskBits=2}})

	-- 이동
	local on_EnterFrame = EnterFrameManager.addListener(function (e)
		-- 화면 밖으로 나갔는지 여부
		local outOfScreen = false

		if direction == "up" then
			bullet.y = bullet.y - bulletSpeed
			if bullet.y < -bullet.height then outOfScreen = true end
		elseif direction == "down" then
			bullet.y = bullet.y + bulletSpeed
			if bullet.y > __appContentHeight__ then outOfScreen = true end
		elseif direction == "left" then
			bullet.x = bullet.x - bulletSpeed
			if bullet.x < -bullet.width then outOfScreen = true end
		elseif direction == "right" then
			bullet.x = bullet.x + bulletSpeed
			if bullet.x > __appContentWidth__ then outOfScreen = true end
		end

		if outOfScreen == true then
			bullet.destroy()
		end
	end)

	--===================================
	--
	-- Public Methods
	--
	--===================================

	-- 총알 제거
	bullet.destroy = function ()
		EnterFrameManager.removeListener(on_EnterFrame)
		bullet:removeSelf()
	end

	return bullet
end

return Class