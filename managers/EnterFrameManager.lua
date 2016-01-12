--=====================================
-- EnterFrame Manager
-- http://spiralcodestudio.com/corona-sdk-pro-tip-of-the-day-28/
-- 수정 : Kangmin Won (http://wonhada.com)
--=====================================

local _M = {}
_M.enterFrameFunctions = nil

local _isPaused = false

-- For internal use
local function _enterFrame()
	if _isPaused == true or _M.enterFrameFunctions == nil or #_M.enterFrameFunctions < 1 then return end
	
	for i = #_M.enterFrameFunctions, 1, -1 do
            -- for문이 돌다가 nil이 되는 경우가 생기므로 return 처리
            if _M.enterFrameFunctions == nil then return end

            local fn = _M.enterFrameFunctions[i]
            if fn ~= nil then fn()
            else _M.removeListener(fn) end
	end
end

-- 초기화
function _M.init()
    _isPaused = false
    _M.removeAllListeners()
end

-- Call f next frame
function _M.nextFrame(f)
	timer.performWithDelay(1, f)
end

-- Call f each frame
function _M.addListener(f)  
	if _M.enterFrameFunctions == nil then
		_M.enterFrameFunctions = {}
		Runtime:addEventListener('enterFrame', _enterFrame)
	end
	table.insert(_M.enterFrameFunctions, f)
	return f
end

-- Stop calling f
function _M.removeListener(f)
	if f == nil or _M.enterFrameFunctions == nil then return end
	local ind = table.indexOf(_M.enterFrameFunctions, f)
	if ind then
		table.remove(_M.enterFrameFunctions, ind)
		if #_M.enterFrameFunctions == 0 then
			Runtime:removeEventListener('enterFrame', _enterFrame)
			_M.enterFrameFunctions = nil
		end
	end
end

-- Stop everything
function _M.removeAllListeners()
	Runtime:removeEventListener('enterFrame', _enterFrame)
	_M.enterFrameFunctions = nil
end

function _M.pause()
	_isPaused = true
end

function _M.resume()
	_isPaused = false
end

function _M.isPaused()
	return _isPaused
end

return _M