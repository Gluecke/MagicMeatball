--Attack of the killer cubes

local composer = require( "composer" )
local scene = composer.newScene()

local widget = require( "widget" )
local json = require( "json" )
local utility = require( "scripts.utility" )
local physics = require( "physics" )
local myData = require( "scripts.mydata" )
local math = require( "math")

-- 
--local variables
--
local xDisplay = display.contentWidth
local yDisplay = display.contentHeight
local vXGravOptions = { text = "xGrav: ", x = xDisplay * .15, y = yDisplay * .05, fontSize = 12, font = native.systemFontBold, align = "left"}
local vYGravOptions = { text = "yGrav: ", x = xDisplay * .15, y = yDisplay * .075,fontSize = 12, font = native.systemFontBold, align = "left"}

local meatBall = display.newCircle( xDisplay / 2, yDisplay / 2, xDisplay * .05 )

local meatBallPhysParams = {

    density = .1,
    friction = .5,
    bounce = 0,
    radius = xDisplay * .05

}

local leftWallPhysParams = { friction=0.5, bounce=0.1 }

local rightWallPhysParams = { friction=0.5, bounce=0.1 }

local topWallPhysParams = { friction=0.5, bounce=0.1 }

local botWallPhysParams = { friction=0.5, bounce=0.1 }

local leftWall = display.newRect( xDisplay * .001, yDisplay , xDisplay * .0001, yDisplay * 2 )
leftWall.strokeWidth = 0
--leftWall:setStrokeColor( gray )

local botWall = display.newRect( xDisplay * .001, yDisplay * .95, xDisplay * 2, yDisplay * .001)
botWall.strokeWidth = 0
-- botWall:setStrokeColor( gray )

local rightWall = display.newRect( xDisplay * .999, yDisplay, xDisplay * .0001, yDisplay * 2)
rightWall.strokeWidth = 0
-- rightWall:setStrokeColor( gray )

local topWall = display.newRect( xDisplay * .001, yDisplay * .15 , xDisplay * 2, yDisplay * .001)
topWall.strokeWidth = 0
-- topWall:setStrokeColor( gray )


--
--local functions
--

local function onAccelerate( event )
    print( event.name, event.xGravity, event.yGravity, event.zGravity )
    local vXPrefix = "xGravety: "
    local vYPrefix = "yGravety: "

    local gravMulti = 5

    local vXForce =  math.round(event.xGravity * gravMulti)
    local vYForce = math.round(event.yGravity * gravMulti) * - 1

    vYGrav.text = vXPrefix .. vYForce
    vXGrav.text = vYPrefix .. vXForce

    meatBall:applyForce( vXForce, vYForce)

end


local function handleWin( event )
    --
    -- When you tap the "I Win" button, reset the "scenes.nextlevel" scene, then goto it.
    --
    -- Using a button to go to the nextlevel screen isn't realistic, but however you determine to 
    -- when the level was successfully beaten, the code below shows you how to call the gameover scene.
    --
    if event.phase == "ended" then
        composer.removeScene("scenes.nextlevel")
        composer.gotoScene("scenes.nextlevel", { time= 500, effect = "crossFade" })
    end
    return true
end

--
-- This function gets called when composer.gotoScene() gets called an either:
--    a) the scene has never been visited before or
--    b) you called composer.removeScene() or composer.removeHidden() from some other
--       scene.  It's possible (and desirable in many cases) to call this once, but 
--       show it multiple times.
--
function scene:create( event )
    --
    -- self in this case is "scene", the scene object for this level. 
    -- Make a local copy of the scene's "view group" and call it "sceneGroup". 
    -- This is where you must insert everything (display.* objects only) that you want
    -- Composer to manage for you.
    local sceneGroup = self.view

    -- 
    -- You need to start the physics engine to be able to add objects to it, but...
    --
    physics.start()
    --
    -- because the scene is off screen being created, we don't want the simulation doing
    -- anything yet, so pause it for now.
    --
    physics.pause()

    --
    -- make a copy of the current level value out of our
    -- non-Global app wide storage table.
    --
    local thisLevel = myData.settings.currentLevel

    --
    -- create your objects here
    --
    physics.addBody( meatBall, meatBallPhysParams )
    meatBall.gravityScale = 0

    physics.addBody( leftWall, "static", leftWallPhysParams )
    physics.addBody( rightWall, "static", rightWallPhysParams )
    physics.addBody( botWall, "static", botWallPhysParams )
    physics.addBody( topWall, "static", topWallPhysParams )
    --
    -- These pieces of the app only need created.  We won't be accessing them any where else
    -- so it's okay to make it "local" here
    --
    local background = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
    background:setFillColor( 0.6, 0.7, 0.3 )
    --
    -- Insert it into the scene to be managed by Composer
    --
    sceneGroup:insert(background)

    vXGrav = display.newText( vXGravOptions )
    vYGrav = display.newText( vYGravOptions )

    sceneGroup:insert(vXGrav)
    sceneGroup:insert(vYGrav)
    sceneGroup:insert( meatBall )
    sceneGroup:insert( leftWall )
    sceneGroup:insert( rightWall )
    sceneGroup:insert( topWall )
    sceneGroup:insert( botWall )


    --
    -- levelText is going to be accessed from the scene:show function. It cannot be local to
    -- scene:create(). This is why it was declared at the top of the module so it can be seen 
    -- everywhere in this module
    levelText = display.newText("", 0, 0, native.systemFontBold, 48 )
    levelText:setFillColor( 0 )
    levelText.x = display.contentCenterX
    levelText.y = display.contentCenterY

    --
    -- Insert it into the scene to be managed by Composer
    --
    sceneGroup:insert( levelText )

    -- 
    -- because we want to access this in multiple functions, we need to forward declare the variable and
    -- then create the object here in scene:create()
    --
    currentScoreDisplay = display.newText("000000", display.contentWidth - 50, 10, native.systemFont, 16 )
    sceneGroup:insert( currentScoreDisplay )

    --
    -- these two buttons exist as a quick way to let you test
    -- going between scenes (as well as demo widget.newButton)
    --

end

--
-- This gets called twice, once before the scene is moved on screen and again once
-- afterwards as a result of calling composer.gotoScene()
--
function scene:show( event )
    --
    -- Make a local reference to the scene's view for scene:show()
    --
    local sceneGroup = self.view

    --
    -- event.phase == "did" happens after the scene has been transitioned on screen. 
    -- Here is where you start up things that need to start happening, such as timers,
    -- tranistions, physics, music playing, etc. 
    -- In this case, resume physics by calling physics.start()
    -- Fade out the levelText (i.e start a transition)
    -- Start up the enemy spawning engine after the levelText fades
    --
    if event.phase == "did" then
         physics.start()
        -- transition.to( levelText, { time = 500, alpha = 0 } )
        -- spawnTimer = timer.performWithDelay( 500, spawnEnemies )

    else -- event.phase == "will"
        -- The "will" phase happens before the scene transitions on screen.  This is a great
        -- place to "reset" things that might be reset, i.e. move an object back to its starting
        -- position. Since the scene isn't on screen yet, your users won't see things "jump" to new
        -- locations. In this case, reset the score to 0.
        currentScore = 0
        currentScoreDisplay.text = string.format( "%06d", currentScore )
    end

    
end

--
-- This function gets called everytime you call composer.gotoScene() from this module.
-- It will get called twice, once before we transition the scene off screen and once again 
-- after the scene is off screen.
function scene:hide( event )
    local sceneGroup = self.view
    
    if event.phase == "will" then
        -- The "will" phase happens before the scene is transitioned off screen. Stop
        -- anything you started elsewhere that could still be moving or triggering such as:
        -- Remove enterFrame listeners here
        -- stop timers, phsics, any audio playing
        --

        --check if this run time listener exits on back butotn press!!!
        Runtime:removeEventListener( "accelerometer", onAccelerate )

        physics.stop()
    end

end

--
-- When you call composer.removeScene() from another module, composer will go through and
-- remove anything created with display.* and inserted into the scene's view group for you. In
-- many cases that's sufficent to remove your scene. 
--
-- But there may be somethings you loaded, like audio in scene:create() that won't be disposed for
-- you. This is where you dispose of those things.
-- In most cases there won't be much to do here.
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
Runtime:addEventListener( "accelerometer", onAccelerate )
return scene