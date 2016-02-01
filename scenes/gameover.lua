local composer = require( "composer" )
local scene = composer.newScene()

local widget = require( "widget" )
local json = require( "json" )
local utility = require( "scripts.utility" )
local myData = require( "scripts.mydata" )
local gameNetwork = require( "gameNetwork" )
local device = require( "scripts.device" )

local xDisplay = display.contentWidth
local yDisplay = display.contentHeight

local flyingMoster = display.newImage( "monster.png" )
flyingMoster.x = xDisplay * .5
flyingMoster.y = yDisplay * .25

local function handleButtonEvent( event )

    if ( "ended" == event.phase ) then
        local options = {
            effect = "crossFade",
            time = 500,
            params = {
                someKey = "someValue",
                someOtherKey = 10
            }
        }
        composer.removeScene( "scenes.menu", false )
        composer.gotoScene( "scenes.menu", options )
    end
    return true
end

local function onAccelerate( event )

    local gravMulti = myData.gravMulti / 2

    local vXForce =  math.round(event.xGravity * gravMulti)
    local vYForce = math.round(event.yGravity * gravMulti) * - 1

    --vYGrav.text = vXPrefix .. vYForce
    --vXGrav.text = vYPrefix .. vXForce

    flyingMoster:applyForce( vXForce, vYForce, flyingMoster.x, flyingMoster.y)
end

--
-- Start the composer event handlers
--
function scene:create( event )
    local sceneGroup = self.view

    params = event.params

    physics.start( )
        
    local gameOverText = display.newText("Game Over", 0, 0, native.systemFontBold, 32 )
    gameOverText:setFillColor( 0 )
    gameOverText.x = display.contentCenterX
    gameOverText.y = 50
    sceneGroup:insert(gameOverText)
    sceneGroup:insert( flyingMoster )

    flyingMoster.isVisible = false

    flyingMoster.isVisible = true

    physics.addBody( flyingMoster, "dynamic" )
    flyingMoster.gravityScale = 0

    sceneGroup:insert( flyingMoster )

    local doneButton = widget.newButton({
        id = "button1",
        label = "ALL HAIL!",
        width = xDisplay,
        height = yDisplay * .15,
        onEvent = handleButtonEvent,
        x = xDisplay * .5,
        y = yDisplay * .85,
        fontSize = yDisplay * .1,
        font = "NoodleScript"
    })
    sceneGroup:insert( doneButton )

    local winSound = myData.winSound

    audio.stop( 1 )

    audio.setVolume( .5, { channel=2 } )

    local options =
        {
            channel = 2,
            duration = 30000,
            fadein = 0
        }

    audio.play(  winSound, options )

end

function scene:show( event )
    local sceneGroup = self.view

    physics.start( )

    params = event.params

    if event.phase == "did" then

    end
end

function scene:hide( event )
    local sceneGroup = self.view

    Runtime:removeEventListener( "accelerometer", onAccelerate )
    
    if event.phase == "will" then
        physics.stop( )
    end

end

function scene:destroy( event )
    local sceneGroup = self.view
    physics.stop( )
    
end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
Runtime:addEventListener( "accelerometer", onAccelerate )
return scene
