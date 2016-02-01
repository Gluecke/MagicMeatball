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
local vXGravOptions = { text = "xGrav: ", x = xDisplay * .15, y = yDisplay * .05, fontSize = yDisplay * 0.05, font = native.systemFontBold, align = "left"}
local vYGravOptions = { text = "yGrav: ", x = xDisplay * .15, y = yDisplay * .1,fontSize = yDisplay * 0.05, font = native.systemFontBold, align = "left"}

local meatBall = display.newImage( "meatball.png", xDisplay * .51, yDisplay * .2 )

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
leftWall.alpha = 0;
--leftWall:setStrokeColor( gray )

local botWall = display.newRect( xDisplay * .001, yDisplay * .95, xDisplay * 2, yDisplay * .001)
botWall.strokeWidth = 0
botWall.alpha = 0;
-- botWall:setStrokeColor( gray )

local rightWall = display.newRect( xDisplay * .999, yDisplay, xDisplay * .0001, yDisplay * 2)
rightWall.strokeWidth = 0
rightWall.alpha = 0;
-- rightWall:setStrokeColor( gray )

local topWall = display.newRect( xDisplay * .001, yDisplay * .15 , xDisplay * 2, yDisplay * .001)
topWall.strokeWidth = 0
topWall.alpha = 0;
-- topWall:setStrokeColor( gray )

local YBoxLoc = yDisplay * .71

local lev1Box1Up = display.newImage( "inactiveTile.png")
lev1Box1Up.x = xDisplay * .51
lev1Box1Up.y = yDisplay * .41
local lev1Box1NotFlipped = 1

local lev1Box1Down = display.newImage( "activeTile.png" )
lev1Box1Down.x = lev1Box1Up.x
lev1Box1Down.y = lev1Box1Up.y
lev1Box1Down.isVisible = false

local lev1Box2Up = display.newImage( "inactiveTile.png")
lev1Box2Up.x = xDisplay * .2
lev1Box2Up.y = YBoxLoc
local lev1Box2NotFlipped = 1

local lev1Box2Down = display.newImage( "activeTile.png" )
lev1Box2Down.x = lev1Box2Up.x
lev1Box2Down.y = lev1Box2Up.y
lev1Box2Down.isVisible = false

local lev1Box3Up = display.newImage( "inactiveTile.png")
lev1Box3Up.x = xDisplay * .81
lev1Box3Up.y = YBoxLoc
local lev1Box3NotFlipped = 1

local lev1Box3Down = display.newImage( "activeTile.png" )
lev1Box3Down.x = lev1Box3Up.x
lev1Box3Down.y = lev1Box3Up.y
lev1Box3Down.isVisible = false

-- Keep track of time in seconds
local secondsLeft = 18

local clockText = display.newText("00:18", display.contentCenterX, yDisplay * .1, "NoodleScript", yDisplay * .09)

local meatBallSound = myData.splatSound

--
--local functions
--
local function updateTime()
    -- decrement the number of seconds
    secondsLeft = secondsLeft - 1
    
    -- time is tracked in seconds.  We need to convert it to minutes and seconds
    local minutes = math.floor( secondsLeft / 60 )
    local seconds = secondsLeft % 60
    
    -- make it a string using string format.  
    local timeDisplay = string.format( "%02d:%02d", minutes, seconds )
    clockText.text = timeDisplay
end

-- run them timer
local countDownTimer = timer.performWithDelay( 1000, updateTime, secondsLeft )

local function onAccelerate( event )
    local vXPrefix = "xGravety: "
    local vYPrefix = "yGravety: "

    local gravMulti = myData.gravMulti

    local vXForce =  math.round(event.xGravity * gravMulti)
    local vYForce = math.round(event.yGravity * gravMulti) * - 1

    --vYGrav.text = vXPrefix .. vYForce
    --vXGrav.text = vYPrefix .. vXForce

    meatBall:applyForce( vXForce, vYForce, meatBall.x, meatBall.y)

end

local function wonGame()

    local options = {
            effect = "crossFade",
            time = 500,
            params = {
                someKey = "someValue",
                someOtherKey = 10
            }
        }
    composer.removeScene( "scenes.game2", false )
    composer.gotoScene( "scenes.game2", options )

end

local function lostGame()

    local options = {
                effect = "crossFade",
                time = 500,
                params = {
                    someKey = "someValue",
                    someOtherKey = 10
                }
            }
    composer.removeScene( "scenes.gamelost", false )
    composer.gotoScene( "scenes.gamelost", options )

end

-- Circle-based collision detection
local function hasCollidedCircle( obj1, obj2 )
    if ( obj1 == nil ) then  -- Make sure the first object exists
        return false
    end
    if ( obj2 == nil ) then  -- Make sure the other object exists
        return false
    end

    local dx = obj1.x - obj2.x
    local dy = obj1.y - obj2.y

    local distance = math.sqrt( dx*dx + dy*dy )
    local objectSize = (obj2.contentWidth/2) + (obj1.contentWidth/2)

    if ( distance < objectSize ) then
        return true
    end
    return false
end

local function checkCollision( event ) 

    if hasCollidedCircle(lev1Box1Up, meatBall) and lev1Box1NotFlipped then
        lev1Box1NotFlipped = 0

        if lev1Box1Up.isVisible then
            audio.play( meatBallSound )
        end

        lev1Box1Up.isVisible = false
        lev1Box1Down.isVisible = true
    end


    if hasCollidedCircle(lev1Box2Up, meatBall) and lev1Box2NotFlipped then
        lev1Box2NotFlipped = 0

        if lev1Box2Up.isVisible then
            audio.play( meatBallSound )
        end

        lev1Box2Up.isVisible = false
        lev1Box2Down.isVisible = true
    end

    if hasCollidedCircle(lev1Box3Up, meatBall) and lev1Box3NotFlipped then
        lev1Box3NotFlipped = 0

        if lev1Box3Up.isVisible then
            audio.play( meatBallSound )
        end

        lev1Box3Up.isVisible = false
        lev1Box3Down.isVisible = true
    end

    if lev1Box3NotFlipped == 0 and lev1Box2NotFlipped == 0 and lev1Box1NotFlipped == 0 then
        wonGame()
    end

    if secondsLeft <= 0 then
        lostGame()
    end

end

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
    local backBackground = display.newRect( xDisplay * .5, yDisplay * .5 , xDisplay, yDisplay )
    sceneGroup:insert( backBackground )

    clockText:setFillColor( 0.7, 0.7, 1 )
    sceneGroup:insert(clockText)

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
    local background = display.newImage( "firstLevel.png", xDisplay * .5, yDisplay * .5 , true)
    --
    -- Insert it into the scene to be managed by Composer
    --
    sceneGroup:insert(background)

    --vXGrav = display.newText( vXGravOptions )
    --vYGrav = display.newText( vYGravOptions )

    --sceneGroup:insert(vXGrav)
    --sceneGroup:insert(vYGrav)
    sceneGroup:insert( meatBall )
    sceneGroup:insert( leftWall )
    sceneGroup:insert( rightWall )
    sceneGroup:insert( topWall )
    sceneGroup:insert( botWall )
    sceneGroup:insert(clockText)

    sceneGroup:insert( lev1Box1Up )
    sceneGroup:insert( lev1Box2Up )
    sceneGroup:insert( lev1Box3Up )
    sceneGroup:insert( lev1Box1Down )
    sceneGroup:insert( lev1Box2Down )
    sceneGroup:insert( lev1Box3Down )


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
    -- currentScoreDisplay = display.newText("000000", display.contentWidth - 50, 10, native.systemFont, 16 )
    -- sceneGroup:insert( currentScoreDisplay )

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
        --currentScore = 0
        -- currentScoreDisplay.text = string.format( "%06d", currentScore )
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
        Runtime:removeEventListener( "accelerometer", checkCollision )

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
Runtime:addEventListener( "accelerometer", checkCollision )
return scene