local GameConfig = require("GameConfig")
local Fonts = require("Fonts")

local Class = {}

Class.create = function (_parent)
	local mainG = display.newGroup()
	_parent:insert(mainG)

	--=========== 코인 관련 Begin ===========--
	local coinTitle = display.newImage(mainG, "images/coin_txt.png", 19, 23)
	__setScaleFactor(coinTitle)

	local coinTxt = display.newText(mainG, GameConfig.getCoin(), coinTitle.x + coinTitle.width + 8, coinTitle.y - 7, 0, 0, Fonts.NotoSans, 21)

	local function on_ChangeCoin(e)
		coinTxt.text = e.coin
	end
	Runtime:addEventListener("changeCoin", on_ChangeCoin)
	--=========== 코인 관련 End ===========--

	--=========== 일시정지 버튼 관련 Begin ===========--
	local pauseBtn = display.newImage(mainG, "images/btn_pause.png", 0, 0)
	__setScaleFactor(pauseBtn)
	pauseBtn.x, pauseBtn.y = __appContentWidth__ - pauseBtn.width -15, 14

	local function on_PauseBtnTap(e)
			GameConfig.pauseGame()
			return true
	end
	pauseBtn:addEventListener("tap", on_PauseBtnTap)
	--=========== 일시정지 버튼 관련 End ===========--

	--=========== 생명 관련 Begin ===========--
	local lifeBox = display.newGroup()
	lifeBox.x, lifeBox.y = 17, __appContentHeight__ - 30
	mainG:insert(lifeBox)

	local function addLife()
		local life = display.newImage(lifeBox, "images/hero_0"..GameConfig.getPlayerSkinType()..".png", 0, 0)
		life.width, life.height = life.width * (__scaleFactor__ * 0.5), life.height * (__scaleFactor__ * 0.5)

		local lastChild = lifeBox[lifeBox.numChildren - 1]
		if lastChild ~= nil then
			life.x = lastChild.x + lastChild.width + 10
		end
	end

	local function subtractLife()
		lifeBox:remove(lifeBox.numChildren)
	end

	local function on_ChangePlayerLifeCount(e)
		local val = e.count - lifeBox.numChildren
		if val < 0 then -- 생명이 줄었음
			for i = math.abs(val), 1, -1 do subtractLife() end
		else -- 생명이 늘었음
			for i = 1, math.abs(val) do addLife() end
		end
	end
	Runtime:addEventListener("changePlayerLifeCount", on_ChangePlayerLifeCount)

	-- 초기 생명 설정
	for i = 1, GameConfig.getPlayerLifeCount() do addLife() end
	--=========== 생명 관련 End ===========--

	-- 게임 오버 이벤트 핸들러
	local function on_GameOver(e)
		Runtime:removeEventListener("changeCoin", on_ChangeCoin)
		pauseBtn:removeEventListener("tap", on_PauseBtnTap)
		Runtime:removeEventListener("changePlayerLifeCount", on_ChangePlayerLifeCount)
	end
	Runtime:addEventListener("gameOver", on_GameOver)

	return mainG
end

return Class
