local ColorUtils = require("utils.ColorUtils")
local Fonts = require("Fonts")

local Class = {}

Class.create = function (type)
	local mainG = display.newGroup()

	-- yes 이벤트 발생
	local function yes(e)
		local evt = {name="result", result="yes"}
		mainG:dispatchEvent(evt)
	end

	-- no 이벤트 발생
	local function no(e)
		local evt = {name="result", result="no"}
		mainG:dispatchEvent(evt)
	end

	-- 배경 생성
	local bg = display.newRect(mainG, 0, 0, __appContentWidth__, __appContentHeight__)
	bg:setFillColor(0, 0, 0, 0.7)
	bg:addEventListener("tap", no)

	--============ 중앙 박스 Begin ============--
	local box = display.newGroup()
	mainG:insert(box)

	local popupBg = display.newRect(box, 0, 0, 238, 178.5)
	popupBg:setFillColor(ColorUtils.hexToPercent("5e1003"))

	local str = (type == "purchase" and "Purchase Now?" or "Apply Now?")
	local titleTxt = display.newText(box, str, 0, 40, 0, 0, Fonts.NotoSans, 20)
	titleTxt.x = (popupBg.width * 0.5) - (titleTxt.width * 0.5)

	local yesBtn = display.newImage(box, "images/purchase_yes.png", 0, 0)
	__setScaleFactor(yesBtn)
	yesBtn.x, yesBtn.y = (popupBg.width * 0.5) - (yesBtn.width) - 8, 100
	yesBtn:addEventListener("tap", yes)

	local noBtn = display.newImage(box, "images/purchase_no.png", 0, 0)
	__setScaleFactor(noBtn)
	noBtn.x, noBtn.y = (popupBg.width * 0.5) + 8, 100
	noBtn:addEventListener("tap", no)

	box.x, box.y = (bg.width * 0.5) - (box.width * 0.5), (bg.height * 0.5) - (box.height * 0.5)
	--============ 중앙 박스 End ============--

	return mainG
end

return Class