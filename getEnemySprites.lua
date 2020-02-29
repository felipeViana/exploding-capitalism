local assets = require "assets"

local getEnemySprites = {}

function getEnemySprites.frente(animationTime, gameFrame)
  local sprite = assets.enemyFrente1
  if math.floor(gameFrame / animationTime*3) == 1 then
    sprite = assets.enemyFrente2
  elseif math.floor(gameFrame / animationTime*3) == 2 then
    sprite = assets.enemyFrente3
  end

  return sprite
end

function getEnemySprites.costas(animationTime, gameFrame)
  local sprite = assets.enemyCostas1
  if math.floor(gameFrame / animationTime*3) == 1 then
    sprite = assets.enemyCostas2
  elseif math.floor(gameFrame / animationTime*3) == 2 then
    sprite = assets.enemyCostas3
  end

  return sprite
end

function getEnemySprites.lado(animationTime, gameFrame)
  local sprite = assets.enemyLado1
  if math.floor(gameFrame / animationTime*3) == 1 then
    sprite = assets.enemyLado2
  elseif math.floor(gameFrame / animationTime*3) == 2 then
    sprite = assets.enemyLado3
  end

  return sprite
end

function getEnemySprites.death(enemyDeathFrame, DEATH_TOTAL_TIME)
  local sprite = assets.enemyDying1
  if math.floor(enemyDeathFrame / DEATH_TOTAL_TIME * 4) == 1 then
    sprite = assets.enemyDying2
  elseif math.floor(enemyDeathFrame / DEATH_TOTAL_TIME * 4) == 2 then
    sprite = assets.enemyDying3
  elseif math.floor(enemyDeathFrame / DEATH_TOTAL_TIME * 4) == 3 then
    sprite = assets.enemyDying4
  end

  return sprite
end

return getEnemySprites
