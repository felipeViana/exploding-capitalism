local sti = require "sti"
local initial_loads = require "initial_loads"

TILE_SIZE = 32
SPRITES_SIZE = 600
SCALE_FACTOR = TILE_SIZE / SPRITES_SIZE
PLAYER_SPEED = 96 -- pixels per second

MAP_SCALE_FACTOR = 2
AVAILABLE_MAP_SIZE = 13
TOTAL_MAP_SIZE = 15

function love.load()
  defaultFont = love.graphics.newFont(12)
  BigFont = love.graphics.newFont(36)

  -- love.graphics.setBackgroundColor(255, 0, 0)

  initial_loads.load_imgs()
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
  -- local sprite = love.graphics.newImage("assets/tiles/tile-green.png")
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
    -- Move player up
    if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
      self.player.y = self.player.y - PLAYER_SPEED * dt
    end

    -- Move player down
    if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
      self.player.y = self.player.y + PLAYER_SPEED * dt
    end

    -- Move player left
    if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
      self.player.x = self.player.x - PLAYER_SPEED * dt
    end

    -- Move player right
    if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
      self.player.x = self.player.x + PLAYER_SPEED * dt
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

    player_tile_position.x = math.floor(self.player.x / TILE_SIZE - 1)
    player_tile_position.y = math.floor(self.player.y / TILE_SIZE - 1)
  end

  -- Draw player
  layer.draw = function(self)
    love.graphics.draw(
      self.player.sprite,
      math.floor(self.player.x),
      math.floor(self.player.y),
      0,
      SCALE_FACTOR,
      SCALE_FACTOR
      -- self.player.ox,
      -- self.player.oy
    )

    -- Temporarily draw a point at our location so we know
    -- that our sprite is offset properly
    love.graphics.setPointSize(5)
    love.graphics.points(math.floor(self.player.x), math.floor(self.player.y))
  end

  -- Remove unneeded object layer
  map:removeLayer("Spawn Point")
end

function love.update(dt)
  if gameIsPaused then
    return
  end

  map:update(dt)
end

function love.draw()
  local screen_width = love.graphics.getWidth() / MAP_SCALE_FACTOR
  local screen_height = love.graphics.getHeight() / MAP_SCALE_FACTOR

  -- Translate world so that player is always centred
  local player = map.layers["Sprites"].player
  local tx = math.floor(player.x - 160)
  tx = math.max(tx, 0)
  tx = math.min(tx, AVAILABLE_MAP_SIZE*TILE_SIZE - screen_width / 4 * 3)

  local ty = math.floor(player.y - 80)
  ty = math.max(ty, 0)
  ty = math.min(ty, AVAILABLE_MAP_SIZE*TILE_SIZE - screen_height / 4 * 3)

  map:draw(-tx, -ty, MAP_SCALE_FACTOR, MAP_SCALE_FACTOR)

  -- love.graphics.setColor(0, 0, 0)

  love.graphics.print("player tile position")
  love.graphics.print(player_tile_position.x, 0, 10)
  love.graphics.print(player_tile_position.y, 0, 20)

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
  -- if key == 'b' then
  --   text = "The B key was released."
  -- elseif key == 'a' then
  --   a_down = false
  -- end
end

function love.focus(f)
  gameIsPaused = not f
end

function love.quit()
  print("Thanks for playing! Made for love 2d jam 2020!")
end
