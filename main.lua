----------------------------------------
-- 이 주석은 삭제하지 마세요.
-- 35% 할인해 드립니다. 코로나 계정 유료 구매시 연락주세요. (Corona SDK, Enterprise, Cards)
-- @Author 아폴로케이션 원강민 대표
-- @Website http://WonHaDa.com, http://Apollocation.com, http://CoronaLabs.kr
-- @E-mail englekk@naver.com, englekk@apollocation.com
-- 'John 3:16, Psalm 23'
-- MIT License :: WonHada Library에 한정되며, 라이선스와 저작권 관련 명시만 지켜주면 되는 라이선스
----------------------------------------

---------------------------------
-- 기본 세팅
-- __statusBarHeight__ : 상단 StatusBar의 높이
-- __appContentWidth__ : App의 너비
-- __appContentHeight__ : App의 높이
-- 앵커포인트는 좌상단 
---------------------------------

-- 안드로이드 풀 스크린 모드 여부
local isAndroidFullScreen = true

local SQLiteManager = require("managers.SQLiteManager")
local GameConfig = require("GameConfig")

-- 이 함수가 시작점입니다. 나머지는 신경쓰지 마세요. (-:
local function startApp()
	require("CommonSettings")

	--========== DB 접속 및 초기화 Begin ==========--
	local exists = SQLiteManager.connectDB("data.db", system.DocumentsDirectory)
	if not exists then -- DB 데이터 초기화
		SQLiteManager.setConfig(GameConfig.DB_PLAYER_SKIN_TYPE, 0)
		SQLiteManager.setConfig(GameConfig.DB_COIN, 0)
		SQLiteManager.setConfig(GameConfig.DB_SOUND_ENABLED, "on")
		SQLiteManager.setConfig(GameConfig.DB_ITEM_PURCHASED_0, 1)
	end
	--========== DB 접속 및 초기화 End ==========--
	
	-- 게임 설정 초기화
	GameConfig.init()

	-- 볼륨 초기화
	local sndEnabled = SQLiteManager.getConfig(GameConfig.DB_SOUND_ENABLED)
	GameConfig.setVolume(sndEnabled == "on" and 1 or 0)
	
	local composer = require "composer"
	composer.gotoScene("MainSceneStarter")
end

--=======================================================--
local function on_SystemEvent(e)
	local _type = e.type
	if _type == "applicationStart" then -- 앱이 시작될 때

		local isResized = false -- 리사이즈 함수 실행 여부

		local function onResized(e1)
			Runtime:removeEventListener("resize", onResized)
			isResized = true

			startApp()
		end

		--======== 안드로이드 풀 스크린 적용(수정 불필요) Begin ========--
		if system.getInfo("environment") == "simulator" or string.lower(system.getInfo("platformName")) ~= "android" or isAndroidFullScreen == false then
			onResized(nil)
		else -- 안드로이드이면서 풀 스크린 모드일 경우
			Runtime:addEventListener("resize", onResized)
			native.setProperty( "androidSystemUiVisibility", "immersiveSticky" )

			-- 소프트키 바가 없는 경우
			local function on_Timer(e2)
				if not isResized then onResized(nil) end
			end
			timer.performWithDelay(200, on_Timer, 1)
		end
		--======== 안드로이드 풀 스크린 적용(수정 불필요) End ========--

	elseif _type == "applicationExit" then -- 앱이 완전히 종료될 때
	elseif _type == "applicationSuspend" then -- 전화를 받거나 홈 버튼 등을 눌러서 앱을 빠져나갈 때
	elseif _type == "applicationResume" then -- Suspend 후 다시 돌아왔을 때
	end
end
Runtime:addEventListener("system", on_SystemEvent)
--=======================================================--