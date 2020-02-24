local sti = require "sti"
local initial_loads = require "initial_loads"
local getPlayerSprites = require "getPlayerSprites"
local getBombSprites = require "getBombSprites"

FULLSCREEN = false

TILE_SIZE = 32
SPRITES_SIZE = 600
SCALE_FACTOR = TILE_SIZE / SPRITES_SIZE
PLAYER_SPEED = 96 -- pixels per second

MAP_SCALE_FACTOR = 3
AVAILABLE_MAP_SIZE = 13
TOTAL_MAP_SIZE = 15

DIRECTIONS = {
  up = {},
  down = {},
  left = {},
  right = {},
}
playerDirection = DIRECTIONS.down

animationTime = 24
walkingFrame = 0
walking = false

deployBomb = false
bombExists = false

bombX = -1
bombY = -1
bombFrame = 0
bombTime = 0
BOMB_LIFE_TIME = 24*4
BOMB_EXPLOSION_LIFE_TIME = 24 * 2

lives = 5

playerImmune = false
immunityTime = 0
IMMUNITY_TOTAL_TIME = 24 * 4

playerDying = false
playerDeathFrame = 0
DEATH_TOTAL_TIME = 24 * 2

EXPLOSION_SIZE = 3

function love.load()
  initial_loads.load_imgs()

  if FULLSCREEN then
    love.window.setFullscreen(true)
  else
    love.window.setMode(800, 600, {fullscreen = false})
  end

  defaultFont = love.graphics.newFont(12)
  BigFont = love.graphics.newFont(36)

  gameIsPaused = false

  map = sti("assets/maps/map1.lua")

  -- Create new dynamic data layer called "Sprites" as the 3º layer
  local layer = map:addCustomLayer("Sprites", 3)

  -- Get player spawn object
  local player
  local enemy1
  local enemy2
  for k, object in pairs(map.objects) do
    if object.name == "Player" then
      player = object
    end

    if object.name == "Enemy1" then
      enemy1 = object
    end
  end

  -- Create player object
  layer.player = {
    sprite = marxFrente1,
    x      = player.x,
    y      = player.y,
  }

  layer.enemy1 = {
    sprite = enemyFrente1,
    x = enemy1.x,
    y = enemy1.y
  }

  player_tile_position = {
    x = 0,
    y = 0,
  }

  layer.update = function(self, dt)
    updatePlayer(self.player, dt)
  end

  layer.draw = function(self)
    drawBomb()
    drawEnemy1()
    drawPlayer()
  end

  -- Remove unneeded object layer
  map:removeLayer("Spawn Point")
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

  player_tile_position.x = math.floor(player.x / TILE_SIZE - 1)
  player_tile_position.y = math.floor(player.y / TILE_SIZE - 1)
end

function drawEnemy1()
  local enemy = map.layers["Sprites"].enemy1

  love.graphics.draw(
    enemy.sprite,
    math.floor(enemy.x),
    math.floor(enemy.y),
    0,
    SCALE_FACTOR,
    SCALE_FACTOR
  )
end

function drawPlayer()
  local player = map.layers["Sprites"].player

  if playerDying then
    playerSprite = getPlayerSprites.death()
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

function respawn()
  playerDying = true
  playerImmune = true
  immunityTime = IMMUNITY_TOTAL_TIME
end

function gameOver()
  love.event.quit(0)
end

function killPlayer()
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
  playerX = math.floor(player.x/TILE_SIZE + 0.5) * TILE_SIZE
  playerY = math.floor(player.y/TILE_SIZE + 0.5) * TILE_SIZE

  if playerX == x and playerY == y then
    killPlayer()
  end
end

function updateBomb()
  local player = map.layers["Sprites"].player
  playerX = player.x
  playerY = player.y

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
    end

    if bombTime > BOMB_EXPLOSION_LIFE_TIME then
      bombExploding = false
      bombTime = 0
      bombFrame = 0
      bombExists = false
    end
  end
end

function updateWalkingFrame()
  if playerDirection == DIRECTIONS.down then
    playerSprite = getPlayerSprites.frente()
  elseif playerDirection == DIRECTIONS.up then
    playerSprite = getPlayerSprites.costas()
  elseif playerDirection == DIRECTIONS.left then
    playerSprite = getPlayerSprites.lado()
  elseif playerDirection == DIRECTIONS.right then
    playerSprite = getPlayerSprites.lado()
  end

  if walking then
    walkingFrame = walkingFrame + 1
  end

  if walkingFrame == animationTime then
    walkingFrame = 0
  end
end

function updateImmunity()
  if not playerImmune then
    return
  end

  immunityTime = immunityTime - 1
  if immunityTime == 0 then
    playerImmune = false
  end
end

function love.update(dt)
  if gameIsPaused then
    return
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
    sprite = getBombSprites.exists()
    love.graphics.draw(sprite, bombX, bombY, 0, SCALE_FACTOR, SCALE_FACTOR)
  end

  if bombExploding then
    for i=-EXPLOSION_SIZE, EXPLOSION_SIZE do
      sprite = getBombSprites.byIndex(i)

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

function drawMap()
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
  drawMap()

  local player = map.layers["Sprites"].player
  love.graphics.print("player position")
  love.graphics.print(player.x, 0, 10)
  love.graphics.print(player.y, 0, 20)

  love.graphics.print("lives", 0, 30)
  love.graphics.print(lives, 0, 40)

  if gameIsPaused then
    love.graphics.setFont(BigFont)
    love.graphics.print("PAUSED", love.graphics.getWidth()/2 - 50, love.graphics.getHeight()/2 - 50)
    love.graphics.setFont(defaultFont)
  end
end

function love.keypressed(key)
  if key == 'p' or key == 'kpenter' or key == 'return' then
    gameIsPaused = not gameIsPaused
  end

  if not bombExists then
    if key == 'b' or key == 'space' then
      deployBomb = true
    end
  end
end

function love.keyreleased(key)
end

function love.focus(f)
  gameIsPaused = not f
end

function love.quit()
  print("Thanks for playing! Made for love 2d jam 2020!")
end
