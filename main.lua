local sti = require "sti"
local initial_loads = require "initial_loads"
local getPlayerSprites = require "getPlayerSprites"

TILE_SIZE = 32
SPRITES_SIZE = 600
SCALE_FACTOR = TILE_SIZE / SPRITES_SIZE
PLAYER_SPEED = 96 -- pixels per second

MAP_SCALE_FACTOR = 3
AVAILABLE_MAP_SIZE = 13
TOTAL_MAP_SIZE = 15

FULLSCREEN = true

DIRECTIONS = {
  up = {},
  down = {},
  left = {},
  right = {},
}
playerDirection = DIRECTIONS.down

animationTime = 24
frame = 0
walking = false

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
  for k, object in pairs(map.objects) do
    if object.name == "Player" then
      player = object
      break
    end
  end

  -- Create player object
  layer.player = {
    sprite = marxFrente1,
    x      = player.x,
    y      = player.y,
    ox = 600,
    oy = 600
  }

  player_tile_position = {
    x = 0,
    y = 0,
  }

  -- Add controls to player
  layer.update = function(self, dt)
    local originalX = self.player.x
    local originalY = self.player.y

    -- Move player up
    if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
      self.player.y = self.player.y - PLAYER_SPEED * dt
      playerDirection = DIRECTIONS.up
    end

    -- Move player down
    if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
      self.player.y = self.player.y + PLAYER_SPEED * dt
      playerDirection = DIRECTIONS.down
    end

    -- Move player left
    if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
      self.player.x = self.player.x - PLAYER_SPEED * dt
      playerDirection = DIRECTIONS.left
    end

    -- Move player right
    if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
      self.player.x = self.player.x + PLAYER_SPEED * dt
      playerDirection = DIRECTIONS.right
    end

    walking = false
    -- trying to move?
    if self.player.x ~= originalX or self.player.y ~= originalY then
      walking = true
    end

    -- limit walls
    if self.player.x < TILE_SIZE then
      self.player.x = TILE_SIZE
    end
    if self.player.x > TILE_SIZE * AVAILABLE_MAP_SIZE then
      self.player.x = TILE_SIZE * AVAILABLE_MAP_SIZE
    end
    if self.player.y < TILE_SIZE then
      self.player.y = TILE_SIZE
    end
    if self.player.y > TILE_SIZE * AVAILABLE_MAP_SIZE then
      self.player.y = TILE_SIZE * AVAILABLE_MAP_SIZE
    end

    -- invalid moviment, collision block
    local step1 = 1.25
    local step2 = 2.75
    for j=0, 5 do
      for i=0, 5 do
        if self.player.x / TILE_SIZE > step1 + i*2 and self.player.x / TILE_SIZE < step2 + i*2 and self.player.y / TILE_SIZE > step1 + j*2 and self.player.y / TILE_SIZE < step2 + j*2 then
          -- if x was right, cancel y
          if originalX / TILE_SIZE > step1 + i*2 and originalX / TILE_SIZE < step2 + i*2 then
            self.player.y = originalY
          end

          -- if x was right, cancel x
          if originalY / TILE_SIZE > step1 + j*2 and originalY / TILE_SIZE < step2 + j*2 then
            self.player.x = originalX
          end
        end
      end
    end

    player_tile_position.x = math.floor(self.player.x / TILE_SIZE - 1)
    player_tile_position.y = math.floor(self.player.y / TILE_SIZE - 1)
  end

  -- Draw player
  layer.draw = function(self)
    if playerDirection == DIRECTIONS.left then
      love.graphics.draw(
        self.player.sprite,
        math.floor(self.player.x),
        math.floor(self.player.y),
        0,
        -SCALE_FACTOR,
        SCALE_FACTOR,
        SPRITES_SIZE,
        0
      )
    else
      love.graphics.draw(
        self.player.sprite,
        math.floor(self.player.x),
        math.floor(self.player.y),
        0,
        SCALE_FACTOR,
        SCALE_FACTOR
      )
    end

    -- love.graphics.setPointSize(5)
    -- love.graphics.points(math.floor(self.player.x), math.floor(self.player.y))
  end

  -- Remove unneeded object layer
  map:removeLayer("Spawn Point")
end

function love.update(dt)
  if gameIsPaused then
    return
  end

  if walking then
    frame = frame + 1
  end

  if playerDirection == DIRECTIONS.down then
    playerSprite = getPlayerSprites.frente()
  elseif playerDirection == DIRECTIONS.up then
    playerSprite = getPlayerSprites.costas()
  elseif playerDirection == DIRECTIONS.left then
    playerSprite = getPlayerSprites.lado()
  elseif playerDirection == DIRECTIONS.right then
    playerSprite = getPlayerSprites.lado()
  end

  if frame == animationTime then
    frame = 0
  end

  map:update(dt)
end

function love.draw()
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

  love.graphics.print("player position")
  love.graphics.print(player.x, 0, 10)
  love.graphics.print(player.y, 0, 20)

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
end

function love.keyreleased(key)
end

function love.focus(f)
  gameIsPaused = not f
end

function love.quit()
  print("Thanks for playing! Made for love 2d jam 2020!")
end
