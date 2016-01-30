local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )
local utility = require( "scripts.utility" )
local ads = require( "ads" )

local params

local myData = require( "scripts.mydata" )

local xDisplay = display.contentWidth
local yDisplay = display.contentHeight


local function handlePlayButtonEvent( event )
    if ( "ended" == event.phase ) then
        composer.removeScene( "scenes.levelselect", false )
        composer.gotoScene("scenes.levelselect", { effect = "crossFade", time = 333 })
    end
end

local function handleHelpButtonEvent( event )
    if ( "ended" == event.phase ) then
        composer.gotoScene("scenes.help", { effect = "crossFade", time = 333, isModal = true })
    end
end

local function handleCreditsButtonEvent( event )

    if ( "ended" == event.phase ) then
        composer.gotoScene("scenes.gamecredits", { effect = "crossFade", time = 333 })
    end
end

local function handleSettingsButtonEvent( event )

    if ( "ended" == event.phase ) then
        composer.gotoScene("scenes.gamesettings", { effect = "crossFade", time = 333 })
    end
end

--
-- Start the composer event handlers
--
function scene:create( event )
    local sceneGroup = self.view

    params = event.params
        
    --
    -- setup a page background, really not that important though composer
    -- crashes out if there isn't a display object in the view.
    --
    --[[
    local background = display.newRect( 0, 0, 570, 360 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    sceneGroup:insert( background )
    --]]

    local title = display.newText("Game Title", xDisplay * .5 , yDisplay * .05, native.systemFontBold, yDisplay * .05 )
    title:setFillColor( 0 )
    sceneGroup:insert( title )

    local yDisplay = display.contentHeight
    local xDisplay = display.contentWidth

    local buttonWidth = xDisplay
    local buttonHeight = yDisplay * .15

    -- Create the widget
    local playButton = widget.newButton({
        id = "button1",
        label = "Play",
        width = buttonWidth,
        height = buttonHeight,
        onEvent = handlePlayButtonEvent,
        fontSize = yDisplay * .1
    })
    playButton.x = xDisplay / 2
    playButton.y = yDisplay * .3
    sceneGroup:insert( playButton )

    -- Create the widget
    local creditsButton = widget.newButton({
        id = "button4",
        label = "Credits",
        width = buttonWidth,
        height = buttonHeight,
        onEvent = handleCreditsButtonEvent,
        fontSize = yDisplay * .1
    })
    creditsButton.x = xDisplay / 2
    creditsButton.y = yDisplay * .3 + buttonHeight
    sceneGroup:insert( creditsButton )

end

function scene:show( event )
    local sceneGroup = self.view

    params = event.params
    utility.print_r(event)

    if params then
        print(params.someKey)
        print(params.someOtherKey)
    end

    if event.phase == "did" then
        composer.removeScene( "scenes.game" ) 
    end
end

function scene:hide( event )
    local sceneGroup = self.view
    
    if event.phase == "will" then
    end

end

function scene:destroy( event )
    local sceneGroup = self.view
    
end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
return scene
