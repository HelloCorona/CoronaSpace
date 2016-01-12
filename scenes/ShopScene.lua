local ColorUtils = require("utils.ColorUtils")
local GameConfig = require("GameConfig")
local ShopItem = require("scenes.controls.ShopItem")
local SQLiteManager = require("managers.SQLiteManager")
local PurchasePopup = require("scenes.controls.PurchasePopup")
local Fonts = require("Fonts")

--##############################  Main Code Begin  ##############################--
local composer = require( "composer" )

local scene = composer.newScene()

local createCenterBox

-- "scene:create()"
function scene:create( event )
	local sceneGroup = self.view

	-- 배경 생성
	local bg = display.newRect(sceneGroup, 0, 0, __appContentWidth__, __appContentHeight__)
	bg:setFillColor(ColorUtils.hexToPercent("c0272c"))

	--=========== 코인 관련 Begin ===========--
	local coinTitle = display.newImage(sceneGroup, "images/coin_txt.png", 19, 23)
	__setScaleFactor(coinTitle)

	local coinTxt = display.newText(sceneGroup, GameConfig.getCoin(), coinTitle.x + coinTitle.width + 8, coinTitle.y - 7, 0, 0, Fonts.NotoSans, 21)

	local function on_ChangeCoin(e)
		coinTxt.text = e.coin
	end
	Runtime:addEventListener("changeCoin", on_ChangeCoin)
	--=========== 코인 관련 End ===========--

	-- 중앙 정렬 박스
	createCenterBox(sceneGroup)

		--============ 뒤로가기 버튼 Begin ============--
	local backBtn = display.newImage(sceneGroup, "images/btn_back.png", 0, 0)
	__setScaleFactor(backBtn, 0.7)
	backBtn.x, backBtn.y = 10, __appContentHeight__ - backBtn.height - 10

	local function on_BackBtnTap(e)
		--======== 씬 이동(현재 씬 제거) Begin ========--
		local currScene = composer.getSceneName("current")
		composer.removeScene(currScene)

		local options = {
			effect = "fade",
			time = 300,
	--			params = nil
		}
		composer.gotoScene(event.params.prevSceneName, options)
		--======== 씬 이동(현재 씬 제거) End ========--
	end
	backBtn:addEventListener("tap", on_BackBtnTap)
	--============ 뒤로가기 버튼 End ============--
end

-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )

-- -------------------------------------------------------------------------------

-- 중앙 정렬 박스 생성
createCenterBox = function (sceneGroup)
	local itemContent, leftBtn, rightBtn
	local margin, itemBoxW, itemBoxH = 10, 170, 160

	local currentItemIdx = 0
	local totalItemCount = 3

	local function changeShowItem(idx)
		transition.to(itemContent, {time=200, x=-(itemBoxW * idx), transition=easing.outQuad})
		currentItemIdx = idx

		leftBtn.isVisible = not (idx <= 0)
		rightBtn.isVisible = not (idx >= (totalItemCount - 1))
	end

	-- 박스 생성
	local box = display.newGroup()
	sceneGroup:insert(box)

	-- 좌측 버튼
	leftBtn = display.newImage(box, "images/btn_left.png", 0, 0)
	__setScaleFactor(leftBtn, 0.7)
	leftBtn.isVisible = false

	local function on_LeftBtnTap(e)
		changeShowItem(currentItemIdx - 1)
	end
	leftBtn:addEventListener("tap", on_LeftBtnTap)

	-- 'SHOP' 타이틀
	local shopTitle = display.newImage(box, "images/title_shop.png", 0, 0)
	__setScaleFactor(shopTitle, 0.7)
	shopTitle.x = (leftBtn.width + margin) + (itemBoxW * 0.5) - (shopTitle.width * 0.5)

	--====== 샵 아이템 Begin ======--
	local itemBox = display.newContainer(box, itemBoxW, itemBoxH)
	itemBox.x, itemBox.y = (leftBtn.width + margin), shopTitle.y + shopTitle.height + 30

	itemContent = display.newGroup()
	itemBox:insert(itemContent)

	-- 아이템 구매 or 적용 선택 이벤트 핸들러
	local function on_ItemSelected(e)
		if e.type == "purchase" and e.cost > GameConfig.getCoin() then -- 코인 부족
			native.showAlert("", "Not enough Coin", {"OK"},
				function (e9)
					native.setProperty( "androidSystemUiVisibility", "immersiveSticky" )
				end
			)
		else -- 구매 가능
			-- 구매 팝업 생성
			local purchasePopup = PurchasePopup.create(e.type)
			local on_Result = function(e2)
				if e2.result == "yes" then
					GameConfig.setPlayerSkinType(e.skinType)
					if e.type == "purchase" then
						-- 구매 저장
						SQLiteManager.setConfig(GameConfig["DB_ITEM_PURCHASED_"..e.skinType], 1)
						-- 코인 차감
						GameConfig.setCoin(GameConfig.getCoin() - e.cost)
						native.showAlert("", "Purchased!", {"OK"},
							function (e9)
								native.setProperty( "androidSystemUiVisibility", "immersiveSticky" )
							end
						)
					else
						native.showAlert("", "Applied!", {"OK"},
							function (e9)
								native.setProperty( "androidSystemUiVisibility", "immersiveSticky" )
							end
						)
					end

					-- 샵아이템들 업데이트
					for i = 1, totalItemCount do
						itemContent[i].update()
					end
				else
					purchasePopup:removeSelf()
					on_Result = nil
				end
			end
			purchasePopup:addEventListener("result", on_Result)
		end
	end

	for i = 0, (totalItemCount - 1) do
		local item = ShopItem.create("hero_0"..i..".png", (i * 1000), i, itemBoxW, itemBoxH)
		item.x, item.y = -(itemBoxW * 0.5) + (i * itemBoxW), -(itemBoxH * 0.5)
		item:addEventListener("itemSelected", on_ItemSelected)
		itemContent:insert(item)
	end

	-- 좌측 버튼 위치 설정
	leftBtn.y = itemBox.y + (itemBoxH * 0.5) - (leftBtn.height * 0.5)

	-- 우측 버튼
	rightBtn = display.newImage(box, "images/btn_right.png", 0, 0)
	__setScaleFactor(rightBtn, 0.7)
	rightBtn.x, rightBtn.y = itemBox.x + itemBoxW + 10, itemBox.y + (itemBoxH * 0.5) - (rightBtn.height * 0.5)

	local function on_RightBtnTap(e)
		changeShowItem(currentItemIdx + 1)
	end
	rightBtn:addEventListener("tap", on_RightBtnTap)
	--====== 샵 아이템 End ======--

	box.x, box.y = (__appContentWidth__ * 0.5) - (box.width * 0.5), (__appContentHeight__ * 0.45) - (box.height * 0.5)
end

-- -------------------------------------------------------------------------------

return scene
--##############################  Main Code End  ##############################--