local assets = require "assets"

local initial_loads = {}

local love = love

function initial_loads.load_imgs()
  assets.marxFrente1 = love.graphics.newImage("assets/imgs/marx-frente-1.png")
  assets.marxFrente2 = love.graphics.newImage("assets/imgs/marx-frente-2.png")
  assets.marxFrente3 = love.graphics.newImage("assets/imgs/marx-frente-3.png")

  assets.marxCostas1 = love.graphics.newImage("assets/imgs/marx-costas-1.png")
  assets.marxCostas2 = love.graphics.newImage("assets/imgs/marx-costas-2.png")
  assets.marxCostas3 = love.graphics.newImage("assets/imgs/marx-costas-3.png")

  assets.marxLado1 = love.graphics.newImage("assets/imgs/marx-lado-1.png")
  assets.marxLado2 = love.graphics.newImage("assets/imgs/marx-lado-2.png")
  assets.marxLado3 = love.graphics.newImage("assets/imgs/marx-lado-3.png")

  assets.marxDying1 = love.graphics.newImage("assets/imgs/marx-dying-1.png")
  assets.marxDying2 = love.graphics.newImage("assets/imgs/marx-dying-2.png")
  assets.marxDying3 = love.graphics.newImage("assets/imgs/marx-dying-3.png")
  assets.marxDying4 = love.graphics.newImage("assets/imgs/marx-dying-4.png")

  assets.bomb1 = love.graphics.newImage("assets/imgs/bomb-1.png")
  assets.bomb2 = love.graphics.newImage("assets/imgs/bomb-2.png")
  assets.bomb3 = love.graphics.newImage("assets/imgs/bomb-3.png")

  assets.explosionCenter1 = love.graphics.newImage("assets/imgs/explosion-center-1.png")
  assets.explosionCenter2 = love.graphics.newImage("assets/imgs/explosion-center-2.png")
  assets.explosionCenter3 = love.graphics.newImage("assets/imgs/explosion-center-3.png")
  assets.explosionCenter4 = love.graphics.newImage("assets/imgs/explosion-center-4.png")

  assets.explosionMiddle = love.graphics.newImage("assets/imgs/explosion-middle.png")
  assets.explosionMiddleTail = love.graphics.newImage("assets/imgs/explosion-middle-tail.png")
  assets.explosionTail = love.graphics.newImage("assets/imgs/explosion-tail.png")

  assets.enemyFrente1 = love.graphics.newImage("assets/imgs/enemy1-frente-1.png")
  assets.enemyFrente2 = love.graphics.newImage("assets/imgs/enemy1-frente-2.png")
  assets.enemyFrente3 = love.graphics.newImage("assets/imgs/enemy1-frente-3.png")

  assets.enemyCostas1 = love.graphics.newImage("assets/imgs/enemy1-costas-1.png")
  assets.enemyCostas2 = love.graphics.newImage("assets/imgs/enemy1-costas-2.png")
  assets.enemyCostas3 = love.graphics.newImage("assets/imgs/enemy1-costas-3.png")

  assets.enemyLado1 = love.graphics.newImage("assets/imgs/enemy1-lado-1.png")
  assets.enemyLado2 = love.graphics.newImage("assets/imgs/enemy1-lado-2.png")
  assets.enemyLado3 = love.graphics.newImage("assets/imgs/enemy1-lado-3.png")

  assets.enemyDying1 = love.graphics.newImage("assets/imgs/enemy1-dying-1.png")
  assets.enemyDying2 = love.graphics.newImage("assets/imgs/enemy1-dying-2.png")
  assets.enemyDying3 = love.graphics.newImage("assets/imgs/enemy1-dying-3.png")
  assets.enemyDying4 = love.graphics.newImage("assets/imgs/enemy1-dying-4.png")

  assets.menuScreen = love.graphics.newImage("assets/imgs/cover.png")
  assets.instructionsScreen = love.graphics.newImage("assets/imgs/instructions.png")
  assets.storyScreen = love.graphics.newImage("assets/imgs/story.png")
  assets.winScreen = love.graphics.newImage("assets/imgs/win-screen.png")
  assets.gameOverScreen = love.graphics.newImage("assets/imgs/game-over-screen.png")
end

return initial_loads
