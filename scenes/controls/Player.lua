local GameConfig = require("GameConfig")

local Class = {}

Class.create = function (_parent)
	local mainG = display.newGroup()
	_parent:insert(mainG)

	local player = display.newGroup()
	mainG:insert(player)

	--============ 불꽃 생성 Begin ============--
	local fire = display.newGroup()
	local options = { frames = require("images.fireSprites").frames }
	local umaSheet = graphics.newImageSheet( "images/fireSprites.png", options )
	local spriteOptions = { name="fireSprites", start=1, count=15, time=300 }
	local spriteInstance = display.newSprite( fire, umaSheet, spriteOptions )
	spriteInstance.anchorX, spriteInstance.anchorY = 0.5, 0
	spriteInstance:play()
	__setScaleFactor(fire)
	mainG:insert(fire)
	--============ 불꽃 생성 End ============--

	--============ 플레이어 스킨 관련 Begfin ============--
	-- 외부에서 직접 스킨을 변경할 수 없음, GameConfig를 통해서만 가능
	local changePlayerSkin = function (type)
		-- 기존 스킨 지우고 새로운 스킨 추가
		if player.numChildren > 0 then player:remove(1) end

		local skin = display.newImage(player, "images/hero_0"..type..".png", 0, 0)
		__setScaleFactor(skin)
		skin.anchorX, skin.anchorY = 0.5, 1
	end

	-- 스킨 변경 이벤트 핸들러
	local function on_ChangePlayerSkinType(e)
		changePlayerSkin(e.type)
	end
	Runtime:addEventListener("changePlayerSkinType", on_ChangePlayerSkinType)

	changePlayerSkin(GameConfig.getPlayerSkinType()) -- 첫 번째 스킨 적용
	--============ 플레이어 스킨 관련 End ============--

	--============ 일시정지 관련 Begin ============--
	local function on_PauseGame(e)
		spriteInstance:pause()
	end
	Runtime:addEventListener("pauseGame", on_PauseGame)

	local function on_ResumeGame(e)
		spriteInstance:play()
	end
	Runtime:addEventListener("resumeGame", on_ResumeGame)
	--============ 일시정지 관련 End ============--

	return mainG
end

return Class