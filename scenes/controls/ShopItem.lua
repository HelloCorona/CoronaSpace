local GameConfig = require("GameConfig")
local SQLiteManager = require("managers.SQLiteManager")

local Class = {}

Class.create = function (itemSrc, cost, skinType, _W, _H)
	local mainG = display.newGroup()

	local bg = display.newRect(mainG, 0, 0, _W, _H)
	bg.alpha = 0

	--============ 아이템 Begin ============--
	local item = display.newImage(mainG, "images/"..itemSrc, 0, 0)
	__setScaleFactor(item, 0.8)
	item.x, item.y = (bg.width * 0.5) - (item.width * 0.5), 30
	--============ 아이템 End ============--

	local btnG = display.newGroup()
	mainG:insert(btnG)

	mainG.update = function ()
		if btnG.numChildren > 0 then btnG:remove(1) end

		if skinType == GameConfig.getPlayerSkinType() then -- 이미 적용중이라면
			local appliedBtn = display.newImage(btnG, "images/btn_applied.png", 0, 0)
			__setScaleFactor(appliedBtn, 0.8)
			appliedBtn.x, appliedBtn.y = (_W * 0.5) - (appliedBtn.width * 0.5), _H - appliedBtn.height
		elseif tonumber(SQLiteManager.getConfig(GameConfig["DB_ITEM_PURCHASED_"..skinType])) == 1 then -- 구매했다면 적용 버튼 생성
			local applyBtn = display.newImage(btnG, "images/btn_apply.png", 0, 0)
			__setScaleFactor(applyBtn, 0.8)
			applyBtn.x, applyBtn.y = (_W * 0.5) - (applyBtn.width * 0.5), _H - applyBtn.height

			local function on_CostkBtnTap(e)
				local evt = {name="itemSelected", target=mainG, type="apply", skinType=skinType}
				mainG:dispatchEvent(evt)
			end
			applyBtn:addEventListener("tap", on_CostkBtnTap)
		else --  구매하지 않았다면 가격 버튼 생성
			local costBtn = display.newImage(btnG, "images/cost"..cost..".png", 0, 0)
			__setScaleFactor(costBtn, 0.8)
			costBtn.x, costBtn.y = (_W * 0.5) - (costBtn.width * 0.5), _H - costBtn.height

			local function on_CostkBtnTap(e)
				local evt = {name="itemSelected", target=mainG, type="purchase", cost=cost, skinType=skinType}
				mainG:dispatchEvent(evt)
			end
			costBtn:addEventListener("tap", on_CostkBtnTap)
		end
	end
	mainG.update()

	return mainG
end

return Class