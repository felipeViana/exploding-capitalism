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

  bomb1 = love.graphics.newImage("assets/imgs/bomb-1.png")
  bomb2 = love.graphics.newImage("assets/imgs/bomb-2.png")
  bomb3 = love.graphics.newImage("assets/imgs/bomb-3.png")

  playerSprites = {
    marxFrente1, marxFrente2, marxFrente3
  }
end


return initial_loads
