local DeviceInfo = require "utils.DeviceInfo"

local Class = {}

Class.NotoSans = (__isSimulator__ and "NotoSans-Bold" or (DeviceInfo.isApple and "NotoSans-Bold" or "NotoSans-Bold"))

--[[
-- iOS용 폰트 찾기
local fonts = native.getFontNames()

local name = "맑은"     -- ttf 파일의 앞 문자를 넣으면 됩니다. mal은 malgun.ttf를 찾기 위해 사용. iOS는 MalgunGothic.

name = string.lower( name )
local fontNames = ""

-- Display each font in the terminal console
for i, fontname in ipairs(fonts) do
	j, k = string.find( string.lower( fontname ), name )
	if( j ~= nil ) then
		print( "fontname = " .. tostring( fontname ) )
		fontNames = fontNames..tostring( fontname )..", "
	end
end
native.showAlert(tostring(fontNames), "", "")
]]

return Class