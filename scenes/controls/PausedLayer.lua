local GameConfig = require("GameConfig")
local composer = require( "composer" )

local physics = require("physics")
local EnterFrameManager = require("managers.EnterFrameManager")

local Class = {}

Class.create = function (_width, _height)
	local mainG = display.newGroup()

	-- 배경 생성
	local bg = display.newRect(mainG, 0, 0, _width, _height)
	bg:setFillColor(0, 0, 0, 0.7)

	-- Fake Event
	local function on_BgTap(e) return true end
	bg:addEventListener("tap", on_BgTap)

	--=============== 버튼 박스 Begin ===============--
	local box = display.newGroup()
	mainG:insert(box)

	local pausedTitle = display.newImage(box, "images/title_pause.png", 0, 0)

	local resumeBtn = display.newImage(box, "images/btn_resume.png", 0, pausedTitle.y + pausedTitle.height + 45)
	resumeBtn.x = (pausedTitle.width * 0.5) - (resumeBtn.width * 0.5)

	local function on_ResumeBtnTap(e)
		GameConfig.resumeGame()
	end
	resumeBtn:addEventListener("tap", on_ResumeBtnTap)

	local quitBtn = display.newImage(box, "images/btn_quit.png", 0, resumeBtn.y + resumeBtn.height + 25)
	quitBtn.x = (pausedTitle.width * 0.5) - (quitBtn.width * 0.5)

	local function on_QuitBtnTap(e)
		-- 모두 정지
		physics.stop()
		EnterFrameManager.removeAllListeners()
		for id, value in pairs(timer._runlist) do
				timer.cancel(value)
		end
		GameConfig.stopBGM()

		-- 게임 오버 이벤트 발생 (GameInfoBox 사용)
		Runtime:dispatchEvent({name="gameOver"})
		
		--======== 씬 이동(현재 씬 제거) Begin ========--
		local currScene = composer.getSceneName("current")
		composer.removeScene(currScene)

		local options = {
			effect = "fade",
			time = 300,
	--			params = nil
		}
		composer.gotoScene("scenes.IntroScene", options)
		--======== 씬 이동(현재 씬 제거) End ========--
	end
	quitBtn:addEventListener("tap", on_QuitBtnTap)

	box.x, box.y = (_width * 0.5) - (box.width * 0.5), (_height * 0.5) - (box.height * 0.5)
	--=============== 버튼 박스 End ===============--

	return mainG
end

return Class