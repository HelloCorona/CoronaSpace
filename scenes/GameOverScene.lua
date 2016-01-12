local ColorUtils = require("utils.ColorUtils")
local GameConfig = require("GameConfig")
local Fonts = require("Fonts")

--##############################  Main Code Begin  ##############################--
local composer = require( "composer" )

local scene = composer.newScene()

-- "scene:create()"
function scene:create( event )
	local sceneGroup = self.view

	GameConfig.playEffectSound("sounds/gameOver.mp3")

	-- 배경 생성
	local bg = display.newRect(sceneGroup, 0, 0, __appContentWidth__, __appContentHeight__)
	bg:setFillColor(ColorUtils.hexToPercent("b8529e"))

	--=============== 중앙 정렬 박스 Begin ===============--
	local box = display.newGroup()
	sceneGroup:insert(box)

	local gameOverTitle = display.newImage(box, "images/gameover.png", 0, 0)

	local scoreTxt = display.newText(box, GameConfig.getCoin(), 0, gameOverTitle.y + gameOverTitle.height + 30, 0, 0, Fonts.NotoSans, 35)
	scoreTxt.x = (gameOverTitle.width * 0.5) - (scoreTxt.width * 0.5)

	--====== 다시 시작 버튼 Begin ======--
	local againBtn = display.newImage(box, "images/btn_again.png", 0, scoreTxt.y + scoreTxt.height + 30)
	againBtn.x = (gameOverTitle.width * 0.5) - (againBtn.width * 0.5)

	local function on_ResumeBtnTap(e)
		GameConfig.stopAllSounds()
		
		--============= 씬 이동(현재 씬 제거) Begin =============--
		local currScene = composer.getSceneName("current")
		composer.removeScene(currScene)

		local options = {
			effect = "fade",
			time = 300,
	--			params = nil
		}
		composer.gotoScene("scenes.GameScene", options)
		--============= 씬 이동(현재 씬 제거) End =============--
	end
	againBtn:addEventListener("tap", on_ResumeBtnTap)
	--====== 다시 시작 버튼 End ======--

	box.x, box.y = (__appContentWidth__ * 0.5) - (box.width * 0.5), (__appContentHeight__ * 0.5) - (box.height * 0.5)
	--=============== 중앙 정렬 박스 End ===============--

	--============ 환경설정 버튼 Begin ============--
	local settingsBtn = display.newImage(sceneGroup, "images/btn_system.png", 0, 0)
	__setScaleFactor(settingsBtn, 0.7)
	settingsBtn.x, settingsBtn.y = 10, __appContentHeight__ - settingsBtn.height - 10

	local function on_SettingsBtnTap(e)
		--======== 씬 이동(현재 씬 제거) Begin ========--
		local options = {
			effect = "fade",
			time = 300,
			params = {prevSceneName="scenes.GameOverScene"}
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
		--======== 씬 이동(현재 씬 제거) Begin ========--
		local options = {
			effect = "fade",
			time = 300,
			params = {prevSceneName="scenes.GameOverScene"}
		}
		composer.gotoScene("scenes.ShopScene", options)
		--======== 씬 이동(현재 씬 제거) End ========--
	end
	shopBtn:addEventListener("tap", on_ShopBtnTap)
	--============ 상점 버튼 End ============--
end

-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )

-- -------------------------------------------------------------------------------

return scene
--##############################  Main Code End  ##############################--