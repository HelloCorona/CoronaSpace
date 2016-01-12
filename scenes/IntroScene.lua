local GameConfig = require("GameConfig")

--##############################  Main Code Begin  ##############################--
local composer = require( "composer" )

local scene = composer.newScene()

local createBg, createUI

-- "scene:create()"
function scene:create( event )
	local sceneGroup = self.view

	-- 배경음악
	GameConfig.playBGM("sounds/intro.mp3")

	-- 배경 생성
	createBg(sceneGroup)

	-- UI 생성
	createUI(sceneGroup)
end

-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )

-- -------------------------------------------------------------------------------

createBg = function (sceneGroup)
	local bg = display.newImage(sceneGroup, "images/intro_bg.png", 0, 0)

	local scaleFactor = __appContentHeight__ / bg.height

	bg.width, bg.height = bg.width * scaleFactor, bg.height * scaleFactor
	bg.x = (__appContentWidth__ * 0.5) - (bg.width * 0.5)

	return bg
end

createUI = function (sceneGroup)
	--============ 타이틀 Begin ============--
	local title = display.newImage(sceneGroup, "images/title.png", 0, 0)
	__setScaleFactor(title, 0.7)
	title.x, title.y = (__appContentWidth__ * 0.5) - (title.width * 0.5), 30
	--============ 타이틀 End ============--

	--============ 플레이 버튼 Begin ============--
	local playBtn = display.newImage(sceneGroup, "images/btn_play.png", 0, 0)
	__setScaleFactor(playBtn, 0.7)
	playBtn.x, playBtn.y = (__appContentWidth__ * 0.5) - (playBtn.width * 0.5), __appContentHeight__ - playBtn.height - 40

	local function on_PlayBtnTap(e)
		GameConfig.stopBGM()

		--======== 씬 이동(현재 씬 제거) Begin ========--
		local currScene = composer.getSceneName("current")
		composer.removeScene(currScene)

		local options = {
			effect = "fade",
			time = 300,
	--			params = nil
		}
		composer.gotoScene("scenes.GameScene", options)
		--======== 씬 이동(현재 씬 제거) End ========--
	end
	playBtn:addEventListener("tap", on_PlayBtnTap)
	--============ 플레이 버튼 End ============--

	--============ 환경설정 버튼 Begin ============--
	local settingsBtn = display.newImage(sceneGroup, "images/btn_system.png", 0, 0)
	__setScaleFactor(settingsBtn, 0.7)
	settingsBtn.x, settingsBtn.y = 10, __appContentHeight__ - settingsBtn.height - 10

	local function on_SettingsBtnTap(e)
		GameConfig.stopBGM()

		--======== 씬 이동(현재 씬 제거) Begin ========--
		local currScene = composer.getSceneName("current")
		composer.removeScene(currScene)

		local options = {
			effect = "fade",
			time = 300,
			params = {prevSceneName="scenes.IntroScene"}
		}
		composer.gotoScene("scenes.SettingsScene", options)
		--======== 씬 이동(현재 씬 제거) End ========--
	end
	settingsBtn:addEventListener("tap", on_SettingsBtnTap)
	--============ 환경설정 버튼 End ============--

	--============ 상점 버튼 Begin ============--
	local shopBtn = display.newImage(sceneGroup, "images/btn_shop.png", 0, 0)
	__setScaleFactor(shopBtn, 0.7)
	shopBtn.x, shopBtn.y = __appContentWidth__ - shopBtn.width - 10, __appContentHeight__ - shopBtn.height - 10

	local function on_ShopBtnTap(e)
		GameConfig.stopBGM()

		--======== 씬 이동(현재 씬 제거) Begin ========--
		local currScene = composer.getSceneName("current")
		composer.removeScene(currScene)

		local options = {
			effect = "fade",
			time = 300,
			params = {prevSceneName="scenes.IntroScene"}
		}
		composer.gotoScene("scenes.ShopScene", options)
		--======== 씬 이동(현재 씬 제거) End ========--
	end
	shopBtn:addEventListener("tap", on_ShopBtnTap)
	--============ 상점 버튼 End ============--
end

-- -------------------------------------------------------------------------------

return scene
--##############################  Main Code End  ##############################--