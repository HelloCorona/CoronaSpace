local ColorUtils = require("utils.ColorUtils")
local GameConfig = require("GameConfig")
local SQLiteManager = require("managers.SQLiteManager")

--##############################  Main Code Begin  ##############################--
local composer = require( "composer" )

local scene = composer.newScene()

-- "scene:create()"
function scene:create( event )
	local sceneGroup = self.view

	-- 배경음악
	GameConfig.playBGM("sounds/settings.mp3")

	-- 배경 생성
	local bg = display.newRect(sceneGroup, 0, 0, __appContentWidth__, __appContentHeight__)
	bg:setFillColor(ColorUtils.hexToPercent("4d4d4d"))

	--=============== 중앙 정렬 박스 Begin ===============--
	local box = display.newGroup()
	sceneGroup:insert(box)

	local hcTitle = display.newImage(box, "images/helloCorona.png", 0, 0)
		__setScaleFactor(hcTitle, 0.6)

		--===== 사운드 버튼 Begin =====--
		local soundBtnG = display.newGroup()
		box:insert(soundBtnG)

		local sndOnBtn, sndOffBtn

		sndOnBtn = display.newImage(soundBtnG, "images/btn_sound_on.png", 0, 0)
		__setScaleFactor(sndOnBtn, 0.6)
		sndOnBtn.isVisible = (SQLiteManager.getConfig(GameConfig.DB_SOUND_ENABLED) == "on")

		local function on_SndOnBtnTap(e)
			SQLiteManager.setConfig(GameConfig.DB_SOUND_ENABLED, "off")
			sndOnBtn.isVisible = false
			sndOffBtn.isVisible = true
			GameConfig.setVolume(0)
		end
		sndOnBtn:addEventListener("tap", on_SndOnBtnTap)

		sndOffBtn = display.newImage(soundBtnG, "images/btn_sound_off.png", 0, 0)
		__setScaleFactor(sndOffBtn, 0.6)
		sndOffBtn.isVisible = (SQLiteManager.getConfig(GameConfig.DB_SOUND_ENABLED) ~= "on")

		local function on_SndOffBtnTap(e)
			SQLiteManager.setConfig(GameConfig.DB_SOUND_ENABLED, "on")
			sndOnBtn.isVisible = true
			sndOffBtn.isVisible = false
			GameConfig.setVolume(1)
		end
		sndOffBtn:addEventListener("tap", on_SndOffBtnTap)

		soundBtnG.x, soundBtnG.y = (hcTitle.width * 0.5) - (soundBtnG.width * 0.5), hcTitle.height + 30
		--===== 사운드 버튼 End =====--

		box.x, box.y = (__appContentWidth__ * 0.5) - (box.width * 0.5), 80
		--=============== 중앙 정렬 박스 End ===============--

		-- Copyright
		local copyright = display.newImage(sceneGroup, "images/create_txt.png", 0, 0)
		__setScaleFactor(copyright, 0.6)
		copyright.x, copyright.y = (__appContentWidth__ * 0.5) - (copyright.width * 0.5), __appContentHeight__ - copyright.height - 60

		--============ 뒤로가기 버튼 Begin ============--
	local backBtn = display.newImage(sceneGroup, "images/btn_back.png", 0, 0)
	__setScaleFactor(backBtn, 0.7)
	backBtn.x, backBtn.y = 10, __appContentHeight__ - backBtn.height - 10

	local function on_BackBtnTap(e)
		GameConfig.stopBGM()

		--======== 씬 이동(현재 씬 제거) Begin ========--
		local currScene = composer.getSceneName("current")
		composer.removeScene(currScene)

		local options = {
			effect = "fade",
			time = 300,
	--			params = nil
		}
		composer.gotoScene(event.params.prevSceneName, options)
		--======== 씬 이동(현재 씬 제거) End ========--
	end
	backBtn:addEventListener("tap", on_BackBtnTap)
	--============ 뒤로가기 버튼 End ============--
end

-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )

-- -------------------------------------------------------------------------------

return scene
--##############################  Main Code End  ##############################--