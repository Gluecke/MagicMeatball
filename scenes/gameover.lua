local composer = require( "composer" )
local scene = composer.newScene()

local widget = require( "widget" )
local json = require( "json" )
local utility = require( "scripts.utility" )
local myData = require( "scripts.mydata" )
local gameNetwork = require( "gameNetwork" )
local device = require( "scripts.device" )

local ads = require( "ads" )

local params

local xDisplay = display.contentWidth
local yDisplay = display.contentHeight

local flyingMoster = display.newImage( "monster.png" )
flyingMoster.x = xDisplay * .5
flyingMoster.y = yDisplay * .25

local winSound = myData.winSound

audio.setVolume( 1, { channel=2 } )

local options =
    {
        channel = 2,
        loops = 0,
        duration = 30000,
        fadein = 5000
    }

audio.play(  winSound, options )

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

--
-- Start the composer event handlers
--
function scene:create( event )
    local sceneGroup = self.view

    params = event.params
        
    local gameOverText = display.newText("Game Over", 0, 0, native.systemFontBold, 32 )
    gameOverText:setFillColor( 0 )
    gameOverText.x = display.contentCenterX
    gameOverText.y = 50
    sceneGroup:insert(gameOverText)
    sceneGroup:insert( flyingMoster )

    local doneButton = widget.newButton({
        id = "button1",
        label = "You WIN!!",
        width = xDisplay,
        height = yDisplay * .15,
        onEvent = handleButtonEvent,
        x = xDisplay * .5,
        y = yDisplay * .85,
        fontSize = yDisplay * .1
    })
    sceneGroup:insert( doneButton )

end

function scene:show( event )
    local sceneGroup = self.view

    physics.start( )

    params = event.params

    if event.phase == "did" then

        flyingMoster.isVisible = false

        flyingMoster.isVisible = true

        physics.addBody( flyingMoster, "dynamic" )
        flyingMoster.gravityScale = .15

        sceneGroup:insert( flyingMoster )


        flyingMoster:applyForce(0, 100, flyingMoster.x, flyingMoster.y)
    end
end

function scene:hide( event )
    local sceneGroup = self.view
    
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
return scene
