local Class = {}

--- Hex code를 RGB 퍼센트로 변환
-- @param hex ex) FF0000
-- @return
Class.hexToPercent = function (hex)
	local r = tonumber(hex:sub(1, 2), 16) / 255
	local g = tonumber(hex:sub(3, 4), 16) / 255
	local b = tonumber(hex:sub(5, 6), 16) / 255
	local a = 255 / 255
	if #hex == 8 then a = tonumber(hex:sub(7, 8), 16) / 255 end
	return r, g, b, a
end

--- Hex code를 RGB 값으로 변환
-- @param hex ex) FF0000
-- @return
Class.hexToRGB = function (hex)
	local r = tonumber(hex:sub(1, 2), 16)
	local g = tonumber(hex:sub(3, 4), 16)
	local b = tonumber(hex:sub(5, 6), 16)
	local a = 255
	if #hex == 8 then a = tonumber(hex:sub(7, 8), 16) end
	return r, g, b, a
end

return Class