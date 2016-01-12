--##############################  Main Code Begin  ##############################--
local composer = require( "composer" )

local scene = composer.newScene()

-- "scene:create()"
function scene:create( event )
	local sceneGroup = self.view
end

-- "scene:show()"
function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
	elseif ( phase == "did" ) then
		-- 첫 씬을 여기서 호출하세요.
		-- 현재 씬 제거
		local currScene = composer.getSceneName("current")
		composer.removeScene(currScene)
		
		local options = {
--			effect = "fade",
--			time = 300,
--			params = nil
		}
		composer.gotoScene("scenes.IntroScene", options)
	end
end

-- "scene:hide()"
function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
	elseif ( phase == "did" ) then
	end
end

-- "scene:destroy()"
function scene:destroy( event )
	local sceneGroup = self.view
end

-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene
--##############################  Main Code End  ##############################--
