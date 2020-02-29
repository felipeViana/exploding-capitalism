local sti = require "sti"
local initial_loads = require "initial_loads"
local assets = require "assets"

local getPlayerSprites = require "getPlayerSprites"
local getEnemySprites = require "getEnemySprites"
local getBombSprites = require "getBombSprites"

local IMAGES_X = 1920
local IMAGES_Y = 1080

local FULLSCREEN = false

local lives = 5

local ENEMY_SPEED = 36

local TILE_SIZE = 32
local SPRITES_SIZE = 600
local SCALE_FACTOR = TILE_SIZE / SPRITES_SIZE
local PLAYER_SPEED = 96 -- pixels per second

local MAP_SCALE_FACTOR = 3
local AVAILABLE_MAP_SIZE = 13

local DIRECTIONS = {
  up = {},
  down = {},
  left = {},
  right = {},
}
local playerDirection = DIRECTIONS.down

local animationTime = 24
local walkingFrame = 0
local walking = false

local deployBomb = false
local bombExists = false

local bombX = -1
local bombY = -1
local bombFrame = 0
local bombTime = 0
local BOMB_LIFE_TIME = 24*4
local BOMB_EXPLOSION_LIFE_TIME = 24 * 2

local playerImmune = false
local immunityTime = 0
local IMMUNITY_TOTAL_TIME = 24 * 4

local playerDying = false
local playerDeathFrame = 0
local DEATH_TOTAL_TIME = 24 * 2

local EXPLOSION_SIZE = 3

local gameFrame = 0

local gameState = "menu"

local gameIsPaused = false

local mediumFont
local BigFont

local map

local bombExploding = false

local playerSprite

local love = love

function love.load()
  initial_loads.load_imgs()

  if FULLSCREEN then
    love.window.setFullscreen(true)
  else
    love.window.setMode(800, 600, {fullscreen = false})
  end

  mediumFont = love.graphics.newFont(24)
  BigFont = love.graphics.newFont(36)

  map = sti("assets/maps/map1.lua")

  -- Create new dynamic data layer called "Sprites" as the 3º layer
  local layer = map:addCustomLayer("Sprites", 3)

  -- Get player spawn object
  local player
  local enemy1
  local enemy2
  for _, object in pairs(map.objects) do
    if object.name == "Player" then
      player = object
    end

    if object.name == "Enemy1" then
      enemy1 = object
    end

    if object.name == "Enemy2" then
      enemy2 = object
    end
  end

  -- Create player object
  layer.player = {
    sprite = assets.marxFrente1,
    x      = player.x,
    y      = player.y,
  }

  layer.enemy1 = {
    sprite = assets.enemyFrente1,
    x = enemy1.x,
    y = enemy1.y,
    direction = DIRECTIONS.up,
    alive = true,
    dying = false,
    deathFrame = 0
  }

  layer.enemy2 = {
    sprite = assets.enemyFrente1,
    x = enemy2.x,
    y = enemy2.y,
    direction = DIRECTIONS.up,
    alive = true,
    dying = false,
    deathFrame = 0
  }

  layer.update = function(self, dt)
    updatePlayer(self.player, dt)
    updateEnemy(self.enemy1, dt, 288, 126)
    updateEnemy(self.enemy2, dt, 160, 256)
  end

  layer.draw = function()
    drawBomb()
    drawEnemy1()
    drawEnemy2()
    drawPlayer()
  end

  -- Remove unneeded object layer
  map:removeLayer("Spawn Point")
end

local function killPlayerAt(x, y)
  explodePlayerAt(x, y)
end

local function adjustToTileCoordinates(x)
  return math.floor(x/TILE_SIZE + 0.5) * TILE_SIZE
end

local function closestInteger(x)
  return math.floor(x + 0.5)
end

local function reachesTile(object, x, y)
  if closestInteger(object.x) == x and closestInteger(object.y) == y then
    return true
  end
  return false
end

function updateEnemy(enemy, dt, startingX, startingY)
  updateEnemySprite(enemy, enemy.direction)

  if enemy.dying then
    enemy.deathFrame = enemy.deathFrame + 1
    if enemy.deathFrame > DEATH_TOTAL_TIME then
      enemy.alive = false
    end
    return
  end

  if not enemy.alive then
    return
  end

  killPlayerAt(adjustToTileCoordinates(enemy.x), adjustToTileCoordinates(enemy.y))

  if enemy.direction == DIRECTIONS.up then
    enemy.y = enemy.y - ENEMY_SPEED * dt
  elseif enemy.direction == DIRECTIONS.right then
    enemy.x = enemy.x + ENEMY_SPEED * dt
  elseif enemy.direction == DIRECTIONS.down then
    enemy.y = enemy.y + ENEMY_SPEED * dt
  else
    enemy.x = enemy.x - ENEMY_SPEED * dt
  end

  if reachesTile(enemy, startingX, startingY-TILE_SIZE) then
    enemy.direction = DIRECTIONS.right
  elseif reachesTile(enemy, startingX+TILE_SIZE*2, startingY-TILE_SIZE) then
    enemy.direction = DIRECTIONS.down
  elseif reachesTile(enemy, startingX+TILE_SIZE*2, startingY+TILE_SIZE) then
    enemy.direction = DIRECTIONS.left
  elseif reachesTile(enemy, startingX, startingY+TILE_SIZE) then
    enemy.direction = DIRECTIONS.up
  end
end

function updateEnemySprite(enemy, direction)
  if enemy.dying then
    enemy.sprite = getEnemySprites.death(enemy.deathFrame, DEATH_TOTAL_TIME)
  elseif direction == DIRECTIONS.down then
    enemy.sprite = getEnemySprites.frente(animationTime, gameFrame)
  elseif direction == DIRECTIONS.up then
    enemy.sprite = getEnemySprites.costas(animationTime, gameFrame)
  elseif direction == DIRECTIONS.right or direction == DIRECTIONS.left then
    enemy.sprite = getEnemySprites.lado(animationTime, gameFrame)
  end
end

function updatePlayer(player, dt)
  if playerDying then
    playerDeathFrame = playerDeathFrame + 1
    if playerDeathFrame > DEATH_TOTAL_TIME then
      playerDying = false
      playerDeathFrame = 0
    end
    return
  end

  local originalX = player.x
  local originalY = player.y

  -- Move player up
  if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
    player.y = player.y - PLAYER_SPEED * dt
    playerDirection = DIRECTIONS.up
  end

  -- Move player down
  if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
    player.y = player.y + PLAYER_SPEED * dt
    playerDirection = DIRECTIONS.down
  end

  -- Move player left
  if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
    player.x = player.x - PLAYER_SPEED * dt
    playerDirection = DIRECTIONS.left
  end

  -- Move player right
  if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
    player.x = player.x + PLAYER_SPEED * dt
    playerDirection = DIRECTIONS.right
  end

  walking = false
  -- trying to move?
  if player.x ~= originalX or player.y ~= originalY then
    walking = true
  end

  -- limit walls
  if player.x < TILE_SIZE then
    player.x = TILE_SIZE
  end
  if player.x > TILE_SIZE * AVAILABLE_MAP_SIZE then
    player.x = TILE_SIZE * AVAILABLE_MAP_SIZE
  end
  if player.y < TILE_SIZE then
    player.y = TILE_SIZE
  end
  if player.y > TILE_SIZE * AVAILABLE_MAP_SIZE then
    player.y = TILE_SIZE * AVAILABLE_MAP_SIZE
  end

  -- invalid moviment, collision block
  local step1 = 1.25
  local step2 = 2.75
  for j=0, 5 do
    for i=0, 5 do
      if player.x / TILE_SIZE > step1 + i*2 and player.x / TILE_SIZE < step2 + i*2 and player.y / TILE_SIZE > step1 + j*2 and player.y / TILE_SIZE < step2 + j*2 then
        -- if x was right, cancel y
        if originalX / TILE_SIZE > step1 + i*2 and originalX / TILE_SIZE < step2 + i*2 then
          player.y = originalY
        end

        -- if x was right, cancel x
        if originalY / TILE_SIZE > step1 + j*2 and originalY / TILE_SIZE < step2 + j*2 then
          player.x = originalX
        end
      end
    end
  end
end

function drawEnemy1()
  drawEnemy(map.layers["Sprites"].enemy1)
end

function drawEnemy2()
  drawEnemy(map.layers["Sprites"].enemy2)
end

function drawEnemy(enemy)
  if not enemy.alive then
    return
  end

  if enemy.direction == DIRECTIONS.left then
    love.graphics.draw(
      enemy.sprite,
      math.floor(enemy.x),
      math.floor(enemy.y),
      0,
      -SCALE_FACTOR,
      SCALE_FACTOR,
      SPRITES_SIZE,
      0
    )
  else
    love.graphics.draw(
      enemy.sprite,
      math.floor(enemy.x),
      math.floor(enemy.y),
      0,
      SCALE_FACTOR,
      SCALE_FACTOR
    )
  end
end

function drawPlayer()
  local player = map.layers["Sprites"].player

  if playerDying then
    playerSprite = getPlayerSprites.death(playerDeathFrame, DEATH_TOTAL_TIME)
  end

  if playerDirection == DIRECTIONS.left then
    love.graphics.draw(
      player.sprite,
      math.floor(player.x),
      math.floor(player.y),
      0,
      -SCALE_FACTOR,
      SCALE_FACTOR,
      SPRITES_SIZE,
      0
    )
  else
    love.graphics.draw(
      player.sprite,
      math.floor(player.x),
      math.floor(player.y),
      0,
      SCALE_FACTOR,
      SCALE_FACTOR
    )
  end
end

function createBombAt(x, y)
  bombX = x
  bombY = y
end

local function respawn()
  playerDying = true
  playerImmune = true
  immunityTime = IMMUNITY_TOTAL_TIME
end

local function gameOver()
  gameState = "gameOver"
end

local function killPlayer()
  if playerImmune then
    return
  end

  lives = lives - 1
  if lives < 0 then
    gameOver()
  else
    respawn()
  end
end

function explodePlayerAt(x, y)
  local player = map.layers["Sprites"].player
  local playerX = adjustToTileCoordinates(player.x)
  local playerY = adjustToTileCoordinates(player.y)

  if playerX == x and playerY == y then
    killPlayer()
  end
end

local function killEnemy(enemy)
  enemy.dying = true
end

local function explodeEnemy1At(x, y)
  local enemy = map.layers["Sprites"].enemy1
  local enemyX = math.floor(enemy.x/TILE_SIZE + 0.5) * TILE_SIZE
  local enemyY = math.floor(enemy.y/TILE_SIZE + 0.5) * TILE_SIZE

  if enemyX == x and enemyY == y then
    killEnemy(enemy)
  end
end

local function explodeEnemy2At(x, y)
  local enemy = map.layers["Sprites"].enemy2
  local enemyX = math.floor(enemy.x/TILE_SIZE + 0.5) * TILE_SIZE
  local enemyY = math.floor(enemy.y/TILE_SIZE + 0.5) * TILE_SIZE

  if enemyX == x and enemyY == y then
    killEnemy(enemy)
  end
end

local function updateBomb()
  local player = map.layers["Sprites"].player
  local playerX = player.x
  local playerY = player.y

  if deployBomb then
    createBombAt(math.floor(playerX/TILE_SIZE+0.5)*TILE_SIZE, math.floor(playerY/TILE_SIZE+0.5)*TILE_SIZE)
    bombExists = true
    deployBomb = false
  end

  if bombExists then
    bombTime = bombTime + 1
    bombFrame = bombFrame + 1
    if bombFrame > animationTime then
      bombFrame = 0
    end
  end

  if not bombExploding then
    if bombTime > BOMB_LIFE_TIME then
      bombExploding = true
      bombTime = 0
      bombFrame = 0
    end
  end

  if bombExploding then
    for i=-EXPLOSION_SIZE, EXPLOSION_SIZE do
      explodePlayerAt(bombX + i * TILE_SIZE, bombY)
      explodePlayerAt(bombX, bombY + i * TILE_SIZE)

      explodeEnemy1At(bombX + i * TILE_SIZE, bombY)
      explodeEnemy1At(bombX, bombY + i * TILE_SIZE)

      explodeEnemy2At(bombX + i * TILE_SIZE, bombY)
      explodeEnemy2At(bombX, bombY + i * TILE_SIZE)
    end

    if bombTime > BOMB_EXPLOSION_LIFE_TIME then
      bombExploding = false
      bombTime = 0
      bombFrame = 0
      bombExists = false
    end
  end
end

local function updateWalkingFrame()
  if playerDirection == DIRECTIONS.down then
    playerSprite = getPlayerSprites.frente(animationTime, walkingFrame)
  elseif playerDirection == DIRECTIONS.up then
    playerSprite = getPlayerSprites.costas(animationTime, walkingFrame)
  elseif playerDirection == DIRECTIONS.left then
    playerSprite = getPlayerSprites.lado(animationTime, walkingFrame)
  elseif playerDirection == DIRECTIONS.right then
    playerSprite = getPlayerSprites.lado(animationTime, walkingFrame)
  end

  if walking then
    walkingFrame = walkingFrame + 1
  end

  if walkingFrame == animationTime then
    walkingFrame = 0
  end
end

local function updateImmunity()
  if not playerImmune then
    return
  end

  immunityTime = immunityTime - 1
  if immunityTime == 0 then
    playerImmune = false
  end
end

local function areAllDead()
  local enemy1 = map.layers["Sprites"].enemy1
  local enemy2 = map.layers["Sprites"].enemy2

  if not enemy1.alive and not enemy2.alive then
    return true
  else
    return false
  end
end

local function checkIfWon()
  if areAllDead() then
    gameState = "won"
  end
end

function love.update(dt)
  if gameState == "quitting" then
    love.event.quit()
  end

  checkIfWon()

  if gameIsPaused then
    return
  end

  gameFrame = gameFrame + 1
  if gameFrame > animationTime then
    gameFrame = 0
  end

  updateImmunity()
  if not playerDying then
    updateWalkingFrame()
  end
  updateBomb()

  map:update(dt)
end

function drawBomb()
  if not bombExists then
    return
  end

  if not bombExploding then
    local sprite = getBombSprites.exists(animationTime, bombFrame)
    love.graphics.draw(sprite, bombX, bombY, 0, SCALE_FACTOR, SCALE_FACTOR)
  end

  if bombExploding then
    for i=-EXPLOSION_SIZE, EXPLOSION_SIZE do
      local sprite = getBombSprites.byIndex(i, animationTime, bombFrame)

      if i < 0 then
        love.graphics.draw(sprite, bombX + i * TILE_SIZE, bombY, 0, SCALE_FACTOR, SCALE_FACTOR)
        love.graphics.draw(sprite, bombX + TILE_SIZE, bombY + i * TILE_SIZE, math.pi/2, SCALE_FACTOR, SCALE_FACTOR)
      elseif i == 0 then
        love.graphics.draw(sprite, bombX, bombY, 0, SCALE_FACTOR, SCALE_FACTOR)
      else
        love.graphics.draw(sprite, bombX + i * TILE_SIZE, bombY, 0, -SCALE_FACTOR, SCALE_FACTOR, SPRITES_SIZE, 0)
        love.graphics.draw(sprite, bombX , bombY + i * TILE_SIZE + TILE_SIZE, math.pi/2*3, SCALE_FACTOR, SCALE_FACTOR)
      end
    end
  end
end

local function drawMap()
  local screen_width = love.graphics.getWidth() / MAP_SCALE_FACTOR
  local screen_height = love.graphics.getHeight() / MAP_SCALE_FACTOR

  local player = map.layers["Sprites"].player
  player.sprite = playerSprite

  -- Translate world so that player is always centred
  local tx = math.floor(player.x - 160)
  tx = math.max(tx, 0)
  tx = math.min(tx, AVAILABLE_MAP_SIZE*TILE_SIZE - screen_width / 4 * 3)

  local ty = math.floor(player.y - 80)
  ty = math.max(ty, 0)
  ty = math.min(ty, AVAILABLE_MAP_SIZE*TILE_SIZE - screen_height / 4 * 3)

  map:draw(-tx, -ty, MAP_SCALE_FACTOR, MAP_SCALE_FACTOR)
end

function love.draw()
  local screenScale = love.graphics.getWidth() / IMAGES_X
  local screenPositionX = 0
  local dy = love.graphics.getHeight() - screenScale * IMAGES_Y
  local screenPositionY = dy/2

  if gameState == "menu" then
    love.graphics.draw(assets.menuScreen, screenPositionX, screenPositionY, 0, screenScale, screenScale)
  elseif gameState == "instructions" then
    love.graphics.draw(assets.instructionsScreen, screenPositionX, screenPositionY, 0, screenScale, screenScale)
  elseif gameState == "story" then
    love.graphics.draw(assets.storyScreen, screenPositionX, screenPositionY, 0, screenScale, screenScale)
  elseif gameState == "won" then
    love.graphics.draw(assets.winScreen, screenPositionX, screenPositionY, 0, screenScale, screenScale)
  elseif gameState == "gameOver" then
    love.graphics.draw(assets.gameOverScreen, screenPositionX, screenPositionY, 0, screenScale, screenScale)
  elseif gameState == "playing" then
    drawMap()

    love.graphics.setColor(0, 0, 0)
    love.graphics.setFont(mediumFont)
    love.graphics.print({"Left: ", lives}, 80, 30, 0, 2, 2)
    love.graphics.setColor(255, 255, 255)

    if gameIsPaused then
      love.graphics.setFont(BigFont)
      love.graphics.setColor(0, 0, 0)
      love.graphics.print("PAUSED", love.graphics.getWidth()/2 - 250, love.graphics.getHeight()/2 - 150, 0, 2, 2)

      love.graphics.setColor(255, 255, 255)
    end
  end
end

local function resetEverything()
  lives = 5
  local player = map.layers["Sprites"].player
  player.x = 32
  player.y = 32

  local enemy1 = map.layers["Sprites"].enemy1
  local enemy2 = map.layers["Sprites"].enemy2

  enemy1.alive = true
  enemy1.dying = false
  enemy1.deathFrame = 0

  enemy2.alive = true
  enemy2.dying = false
  enemy2.deathFrame = 0

  bombExploding = false
  bombExists = false

  playerDirection = DIRECTIONS.down
end

function love.keypressed(key)
  if gameState == "menu" then
    if key == 'p' or key == 'kpenter' or key == 'return' then
      gameState = "story"
    end

    if key == 'i' then
      gameState = "instructions"
    end

    if key == 'q' then
      gameState = "quitting"
    end
  elseif gameState == "instructions" then
    if key == 'p' or key == 'kpenter' or key == 'return' then
      gameState = "story"
    end

    if key == 'q' then
      gameState = "quitting"
    end
  elseif gameState == "story" then
    if key == 'p' or key == 'kpenter' or key == 'return' then
      gameState = "playing"
    end

    if key == 'q' then
      gameState = "quitting"
    end
  elseif gameState == "playing" then
    if key == 'p' or key == 'kpenter' or key == 'return' then
      gameIsPaused = not gameIsPaused
    end

    if not bombExists then
      if key == 'b' or key == 'space' then
        deployBomb = true
      end
    end
  elseif gameState == "gameOver" or gameState == "won" then
    if key == 'p' or key == 'kpenter' or key == 'return' then
      gameState = "playing"
      resetEverything()
    end
    if key == 'q' then
      gameState = "quitting"
    end
  end
end

function love.focus(f)
  gameIsPaused = not f
end

function love.quit()
  print("Thanks for playing! Made for love 2d jam 2020!")
end
