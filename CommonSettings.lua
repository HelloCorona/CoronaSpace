----------------------------------------
-- 이 주석은 삭제하지 마세요.
-- 35% 할인해 드립니다. 코로나 계정 유료 구매시 연락주세요. (Corona SDK, Enterprise, Cards)
-- @Author 아폴로케이션 원강민 대표
-- @Website http://WonHaDa.com, http://Apollocation.com, http://CoronaLabs.kr
-- @E-mail englekk@naver.com, englekk@apollocation.com
-- 'John 3:16, Psalm 23'
-- MIT License :: WonHada Library에 한정되며, 라이선스와 저작권 관련 명시만 지켜주면 되는 라이선스
----------------------------------------

--[[
	개발 편의를 위한 Global 변수들
	__statusBarHeight__ -- StatusBar 높이
	__appContentWidth__ -- application.content.width
	__appContentHeight__ -- application.content.height
	__isSimulator__ -- 시뮬레이터에서 실행중인지 여부
]]

-- 상태바 타입을 입력하세요.
local statusBarType = "hidden" -- 소문자로.. hidden, default, translucent, dark

--====================================--
-- 주의!! 아래 코드부터 수정하지 마세요.
if statusBarType == "hidden" then
	display.setStatusBar( display.HiddenStatusBar )

    __statusBarHeight__ = 0 -- StatusBar의 높이
else
	if statusBarType == "default" then display.setStatusBar( display.DefaultStatusBar )
	elseif statusBarType == "translucent" then display.setStatusBar( display.TranslucentStatusBar )
	elseif statusBarType == "dark" then display.setStatusBar( display.DarkStatusBar ) end
	
	__statusBarHeight__ = display.topStatusBarContentHeight -- StatusBar의 높이
end
-- App의 너비, 높이
__appContentWidth__ = display.actualContentWidth
__appContentHeight__ = display.actualContentHeight
__isSimulator__ = system.getInfo("environment") == "simulator"
__scaleFactor__ = 0.5 -- 모든 크기의 기준이 되는 비율 기준값
__setScaleFactor = function (obj, ratio)
	ratio = ratio or __scaleFactor__
	obj.width, obj.height = obj.width * ratio, obj.height * ratio
end
--====================================--

-- Global 변수값 확인
-- print(__statusBarHeight__, __appContentWidth__, __appContentHeight__, __isSimulator__)

-- 앵커포인트 좌상단으로 세팅
display.setDefault( "anchorX", 0 )
display.setDefault( "anchorY", 0 )

math.randomseed(os.time())