local EnterFrameManager = require("managers.EnterFrameManager")
local SQLiteManager = require("managers.SQLiteManager")

local Class = {}

Class.DB_PLAYER_SKIN_TYPE = "playerSkinType" -- 0 ~ 2
Class.DB_COIN = "coin" -- int
Class.DB_SOUND_ENABLED = "soundEnabled" -- on or off
Class.DB_ITEM_PURCHASED_0 = "itemPurchased0" -- 0 or 1
Class.DB_ITEM_PURCHASED_1 = "itemPurchased1" -- 0 or 1
Class.DB_ITEM_PURCHASED_2 = "itemPurchased2" -- 0 or 1

-- 게임 레벨(0 ~ 3)
Class.gameLevel = 0

--========= 플레이어 스킨 타입 Get/Set Begin =========--
local _playerSkinType -- 0 ~ 2

Class.getPlayerSkinType = function ()
	return tonumber(_playerSkinType)
end

Class.setPlayerSkinType = function (value)
	_playerSkinType = tonumber(value)

	-- DB 업데이트
	SQLiteManager.setConfig(Class.DB_PLAYER_SKIN_TYPE, _playerSkinType)

	local evt = {name="changePlayerSkinType", type=_playerSkinType}
	Runtime:dispatchEvent(evt)
end
--========= 플레이어 스킨 타입 Get/Set End =========--

--========= 플레이어 생명 갯수 Get/Set Begin =========--
local _playerLifeCount

Class.getPlayerLifeCount = function ()
	return tonumber(_playerLifeCount)
end

Class.setPlayerLifeCount = function (value)
	_playerLifeCount = tonumber(value)

	local evt = {name="changePlayerLifeCount", count=_playerLifeCount}
	Runtime:dispatchEvent(evt)
end
--========= 플레이어 생명 갯수 Get/Set End =========--

--========= 점수(코인) 관련 Get/Set Begin =========--
local _coin

Class.getCoin = function ()
	return tonumber(_coin)
end

Class.setCoin = function (value)
	_coin = tonumber(value)

	-- DB 업데이트
	SQLiteManager.setConfig(Class.DB_COIN, _coin)

	local evt = {name="changeCoin", coin=_coin}
	Runtime:dispatchEvent(evt)
end
--========= 점수(코인) 관련 Get/Set End =========--

--========= 일시정지 관련 Get/Fn Begin =========--
local _isPaused = false

Class.isPaused = function ()
	return _isPaused
end

Class.pauseGame = function (dispatchEvent)
	dispatchEvent = dispatchEvent or true

	if _isPaused == true then return end

	_isPaused = true

	if dispatchEvent == true then Runtime:dispatchEvent({name="pauseGame"}) end
end

Class.resumeGame = function (dispatchEvent)
	dispatchEvent = dispatchEvent or true

	if _isPaused == false then return end

	_isPaused = false

	if dispatchEvent == true then Runtime:dispatchEvent({name="resumeGame"}) end
end
--========= 일시정지 관련 Get/Fn End =========--

--========= 사운드 제어 Begin =========--
local bgmChannel = nil
Class.playBGM = function (sndPath)
	Class.stopBGM()
	
	local gbm = audio.loadStream(sndPath)
	bgmChannel = audio.play( gbm, { channel=1, loops=-1 } )
end

Class.stopBGM = function ()
	if bgmChannel ~= nil then audio.stop(bgmChannel) end
	bgmChannel = nil
end

Class.playEffectSound = function (sndPath)
	local snd = audio.loadSound(sndPath)
	local availableChannel = audio.findFreeChannel()
	audio.play( snd, { channel=availableChannel } )
end

Class.stopAllSounds = function ()
	audio.stop()
end

Class.setVolume = function (value)
	audio.setVolume(value)
end
--========= 사운드 제어 End =========--

--========= 설정 초기화 Begin =========--
Class.init = function ()
	Class.gameLevel = 0
	_playerSkinType = tonumber(SQLiteManager.getConfig(Class.DB_PLAYER_SKIN_TYPE))
	_playerLifeCount = 4
	_coin = tonumber(SQLiteManager.getConfig(Class.DB_COIN))
	_isPaused = false

	EnterFrameManager.init()
end
--========= 설정 초기화 End =========--

return Class