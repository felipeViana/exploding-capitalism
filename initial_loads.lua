local initial_loads = {}

function initial_loads.load_imgs()
  marxFrente1 = love.graphics.newImage("assets/imgs/marx-frente-1.png")
  marxFrente2 = love.graphics.newImage("assets/imgs/marx-frente-2.png")
  marxFrente3 = love.graphics.newImage("assets/imgs/marx-frente-3.png")

  marxCostas1 = love.graphics.newImage("assets/imgs/marx-costas-1.png")
  marxCostas2 = love.graphics.newImage("assets/imgs/marx-costas-2.png")
  marxCostas3 = love.graphics.newImage("assets/imgs/marx-costas-3.png")

  marxLado1 = love.graphics.newImage("assets/imgs/marx-lado-1.png")
  marxLado2 = love.graphics.newImage("assets/imgs/marx-lado-2.png")
  marxLado3 = love.graphics.newImage("assets/imgs/marx-lado-3.png")

  marxDying1 = love.graphics.newImage("assets/imgs/marx-dying-1.png")
  marxDying2 = love.graphics.newImage("assets/imgs/marx-dying-2.png")
  marxDying3 = love.graphics.newImage("assets/imgs/marx-dying-3.png")
  marxDying4 = love.graphics.newImage("assets/imgs/marx-dying-4.png")

  bomb1 = love.graphics.newImage("assets/imgs/bomb-1.png")
  bomb2 = love.graphics.newImage("assets/imgs/bomb-2.png")
  bomb3 = love.graphics.newImage("assets/imgs/bomb-3.png")

  explosionCenter1 = love.graphics.newImage("assets/imgs/explosion-center-1.png")
  explosionCenter2 = love.graphics.newImage("assets/imgs/explosion-center-2.png")
  explosionCenter3 = love.graphics.newImage("assets/imgs/explosion-center-3.png")
  explosionCenter4 = love.graphics.newImage("assets/imgs/explosion-center-4.png")

  explosionMiddle = love.graphics.newImage("assets/imgs/explosion-middle.png")
  explosionMiddleTail = love.graphics.newImage("assets/imgs/explosion-middle-tail.png")
  explosionTail = love.graphics.newImage("assets/imgs/explosion-tail.png")

  enemyFrente1 = love.graphics.newImage("assets/imgs/enemy1-frente-1.png")
  enemyFrente2 = love.graphics.newImage("assets/imgs/enemy1-frente-2.png")
  enemyFrente3 = love.graphics.newImage("assets/imgs/enemy1-frente-3.png")

  enemyCostas1 = love.graphics.newImage("assets/imgs/enemy1-costas-1.png")
  enemyCostas2 = love.graphics.newImage("assets/imgs/enemy1-costas-2.png")
  enemyCostas3 = love.graphics.newImage("assets/imgs/enemy1-costas-3.png")

  enemyLado1 = love.graphics.newImage("assets/imgs/enemy1-lado-1.png")
  enemyLado2 = love.graphics.newImage("assets/imgs/enemy1-lado-2.png")
  enemyLado3 = love.graphics.newImage("assets/imgs/enemy1-lado-3.png")

  enemyDying1 = love.graphics.newImage("assets/imgs/enemy1-dying-1.png")
  enemyDying2 = love.graphics.newImage("assets/imgs/enemy1-dying-2.png")
  enemyDying3 = love.graphics.newImage("assets/imgs/enemy1-dying-3.png")
  enemyDying4 = love.graphics.newImage("assets/imgs/enemy1-dying-4.png")

  menuScreen = love.graphics.newImage("assets/imgs/cover.png")
  instructionsScreen = love.graphics.newImage("assets/imgs/instructions.png")
  storyScreen = love.graphics.newImage("assets/imgs/story.png")
  winScreen = love.graphics.newImage("assets/imgs/win-screen.png")
  gameOverScreen = love.graphics.newImage("assets/imgs/game-over-screen.png")
end

return initial_loads
