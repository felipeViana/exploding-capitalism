local sti = require "sti"
local initial_loads = require "initial_loads"

TILE_SIZE = 32
SPRITES_SIZE = 600
SCALE_FACTOR = TILE_SIZE / SPRITES_SIZE
PLAYER_SPEED = 96 -- pixels per second

MAP_SCALE_FACTOR = 2
AVAILABLE_MAP_SIZE = 14
TOTAL_MAP_SIZE = 16

function love.load()
  initial_loads.load_imgs()
  gameIsPaused = false

  map = sti("assets/maps/map1.lua")

  -- Create new dynamic data layer called "Sprites" as the 8th layer
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
  tx = math.min(tx, (AVAILABLE_MAP_SIZE/2+1)*TILE_SIZE)

  local ty = math.floor(player.y - 80)
  ty = math.max(ty, 0)
  ty = math.min(ty, AVAILABLE_MAP_SIZE*TILE_SIZE)

  map:draw(-tx, -ty, MAP_SCALE_FACTOR, MAP_SCALE_FACTOR)
end

function love.keypressed(key)
   -- if key == 'b' then
   --    text = "The B key was pressed."
   -- elseif key == 'a' then
   --    a_down = true
   -- end
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
