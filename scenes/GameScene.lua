local Player = require("scenes.controls.Player")
local Bullet = require("scenes.controls.Bullet")
local Enemy = require("scenes.controls.Enemy")
local GameInfoBox = require("scenes.controls.GameInfoBox")
local GameConfig = require("GameConfig")
local EnterFrameManager = require("managers.EnterFrameManager")
local PausedLayer = require("scenes.controls.PausedLayer")
local particleDesigner = require( "managers.particleDesigner" )

local physics = require("physics")
--physics.setDrawMode("hybrid")
physics.start()
physics.setGravity(0, 0)

--##############################  Main Code Begin  ##############################--
local composer = require( "composer" )

local scene = composer.newScene()

local createBg, createPlayer, createEnemyFactory, setTouchEvent, gameOver
local createEnemyTimer, pausedLayer

-- "scene:create()"
function scene:create( event )
	local sceneGroup = self.view

	-- 게임 데이터 초기화
	GameConfig.init()

	-- 배경음악
	GameConfig.playBGM("sounds/game.mp3")

	-- 배경
	local bg = createBg(sceneGroup)

	--================ 전투 레이어 Begin ================--
	-- 전투 레이어 생성
	local warLayer = display.newGroup()
	sceneGroup:insert(warLayer)

	-- 주인공
	local player = createPlayer(warLayer)

	-- 적기 생성
	createEnemyFactory(warLayer)

	-- 화면 터치 설정
	setTouchEvent(bg, warLayer, player)
	--================ 전투 레이어 End ================--

	-- 게임 정보 UI
	local gameInfoLayer = GameInfoBox.create(sceneGroup)

	--================ 이벤트 처리 Begin ================--
	-- 일시 정지
	local function on_PauseGame(e)
		pausedLayer = PausedLayer.create(__appContentWidth__, __appContentHeight__)
		sceneGroup:insert(pausedLayer)

		physics.pause()
		EnterFrameManager.pause()
		timer.pause(createEnemyTimer)
	end
	Runtime:addEventListener("pauseGame", on_PauseGame)

	-- 재개
	local function on_ResumeGame(e)
		pausedLayer:removeSelf()

		physics.start()
		EnterFrameManager.resume()
		timer.resume(createEnemyTimer)
	end
	Runtime:addEventListener("resumeGame", on_ResumeGame)
	--================ 이벤트 처리 End ================--
end

-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )

-- -------------------------------------------------------------------------------

-- 배경 생성
createBg = function (sceneGroup)
	local bg = display.newImage(sceneGroup, "images/game_bg.png", 0, 0)

	local scaleFactor = __appContentHeight__ / bg.height

	bg.width, bg.height = bg.width * scaleFactor, bg.height * scaleFactor
	bg.x = (__appContentWidth__ * 0.5) - (bg.width * 0.5)

	return bg
end

createPlayer = function(warLayer)
	local player = Player.create(warLayer)
	player.x, player.y = __appContentWidth__ * 0.5, __appContentHeight__ - 30
	return player
end

-- 적기 생성 (create 이벤트 핸들러의 코드가 복잡해서 따로 분리)
createEnemyFactory = function (warLayer)
	-- 적기를 중심으로 파편 생성
	local function createPieces(enemy)
		local enemyInfo = {x=enemy.x, y=enemy.y, width=enemy.width, height=enemy.height}
		local function on_CreatePieces(e2)
			local dirList = {"up", "down", "left", "right"}
			for i = 1, 4 do
				local piece = Bullet.create(warLayer, "piece.png", dirList[i], 4)
				piece.x, piece.y = enemyInfo.x + (enemyInfo.width * 0.5) + (piece.width * 0.5), enemyInfo.y + (enemyInfo.height * 0.5) - (piece.height * 0.5)
			end
		end
		timer.performWithDelay(10, on_CreatePieces, 1)
	end

	-- 적기 생성
	local enemyCreationCount = 0
	local function createEnemy(event)
		local enemy = Enemy.create(warLayer)
		enemy.x, enemy.y = __appContentWidth__, math.random(0, __appContentHeight__ * 0.5)

		--===== 게임 레벨 업그레이드 Begin =====--
		enemyCreationCount = enemyCreationCount + 1
		if enemyCreationCount == 4 then
			GameConfig.gameLevel = 1
		elseif enemyCreationCount == 10 then
			GameConfig.gameLevel = 2
		elseif enemyCreationCount == 20 then
			GameConfig.gameLevel = 3
		end
		--===== 게임 레벨 업그레이드 End =====--

		-- 충돌 이벤트 핸들러
		enemy.on_EnermyPreCollision = function(e2)
			local _enemy = e2.target
			_enemy:removeEventListener("preCollision", _enemy.on_EnermyPreCollision)

			-- 점수 올리기
			local score = 10
			if enemy.type == 1 then score = 20
			elseif enemy.type == 2 then score = 50
			elseif enemy.type == 3 then score = 100 end
			GameConfig.setCoin(GameConfig.getCoin() + score)

			-- 폭파 파티클
			local emitter = particleDesigner.newEmitter("images/ExplorParticle.json")
			emitter.x, emitter.y = _enemy.x + (_enemy.width * 0.5), _enemy.y + (_enemy.height * 0.5)

			-- 적기 파편 생성
			createPieces(_enemy)

			_enemy.on_EnermyPreCollision = nil

			-- 폭파음
			GameConfig.playEffectSound("sounds/explo.wav")

			e2.other.destroy()
			_enemy.destroy()
		end
		enemy:addEventListener("preCollision", enemy.on_EnermyPreCollision)

		-- object 흔들기
		local shakeObject = function (object)
			local duration = 40
			local amplitude = 5
			local removeTime = 40

			transition.to(object, { time = removeTime * 0.2, x = amplitude, y = amplitude })
			local forty = removeTime * 0.025
			for a = 1, duration, 1 do
				transition.to(object, { delay = 0 + (forty * 3 * a), time = forty, x = -amplitude * 0.5, y = -amplitude * 0.5 })
				transition.to(object, { delay = forty + (forty * 3 * a), time = forty, x = amplitude * 0.5, y = -amplitude * 0.5 })
				transition.to(object, { delay = (forty * 2) + (forty * 3 * a), time = forty, x = -amplitude * 0.5, y = amplitude * 0.5 })
				transition.to(object, { delay = (forty * 3) + (forty * 3 * a), time = forty, x = 0, y = 0 })
			end
		end

		-- 적기 침입 이벤트 핸들러
		local function on_Invaded(e2)
			GameConfig.playEffectSound("sounds/invade.mp3")

			shakeObject(warLayer) -- 충돌 효과

			GameConfig.setPlayerLifeCount(GameConfig.getPlayerLifeCount() - 1)
			if GameConfig.getPlayerLifeCount() < 1 then
				-- 게임 오버
				gameOver()
			end
		end
		enemy:addEventListener("invaded", on_Invaded)
	end
	createEnemyTimer = timer.performWithDelay(2500, createEnemy, 0)
	createEnemy() -- 첫 번째 적기 생성
end

-- 화면 터치 설정 (create 이벤트 핸들러의 코드가 복잡해서 따로 분리)
setTouchEvent = function (bg, warLayer, player)
	local touchEnabled = true -- 화면 터치 가능 여부

	local function touchReEnable(e2)
		touchEnabled = true
	end

	local function on_BgTap(e)
		if touchEnabled == false or GameConfig.isPaused() then return end
		
		-- 1초동안 터치 불가
		touchEnabled = false

		-- 주인공 총알 생성
		local _skinType = GameConfig.getPlayerSkinType() -- 0 ~ 2
		if _skinType == 0 then
			local bullet = Bullet.create(warLayer, "bullet.png", "up", 2.2)
			bullet.x, bullet.y = player.x - (bullet.width * 0.5), player.y - (player.height * 0.5)
		elseif _skinType == 1 then
			local bullet1 = Bullet.create(warLayer, "bullet.png", "up", 3.0)
			bullet1.x, bullet1.y = player.x - (bullet1.width * 0.5) - 5, player.y - (player.height * 0.5)

			local bullet2 = Bullet.create(warLayer, "bullet.png", "up", 3.0)
			bullet2.x, bullet2.y = player.x - (bullet2.width * 0.5) + 5, player.y - (player.height * 0.5)
		elseif _skinType == 2 then
			local bullet = Bullet.create(warLayer, "bullet.png", "up", 2.7)
			bullet.x, bullet.y = player.x - (bullet.width * 0.5), player.y - (player.height * 0.5)

			local bullet1 = Bullet.create(warLayer, "bullet.png", "up", 3.5)
			bullet1.x, bullet1.y = player.x - (bullet1.width * 0.5) - 10, player.y - (player.height * 0.5)

			local bullet2 = Bullet.create(warLayer, "bullet.png", "up", 3.5)
			bullet2.x, bullet2.y = player.x - (bullet2.width * 0.5) + 10, player.y - (player.height * 0.5)
		end

				GameConfig.playEffectSound("sounds/shoot.wav")

		timer.performWithDelay(1000, touchReEnable, 1) -- 다시 터치 가능하도록 전환
	end
	bg:addEventListener("tap", on_BgTap)
end
-- -------------------------------------------------------------------------------

-- 게임 오버
gameOver = function()
	-- 모두 정지
	physics.stop()
	EnterFrameManager.removeAllListeners()
	for id, value in pairs(timer._runlist) do
		timer.cancel(value)
	end
	GameConfig.stopBGM()

	-- 게임 오버 이벤트 발생 (GameInfoBox 사용)
	Runtime:dispatchEvent({name="gameOver"})

	--============= 씬 이동(현재 씬 제거) Begin =============--
	local currScene = composer.getSceneName("current")
	composer.removeScene(currScene)

	local options = {
		effect = "fade",
		time = 300,
--			params = nil
	}
	composer.gotoScene("scenes.GameOverScene", options)
	--============= 씬 이동(현재 씬 제거) End =============--
end

return scene
--##############################  Main Code End  ##############################--