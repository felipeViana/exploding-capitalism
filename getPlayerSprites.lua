local assets = require "assets"

local getPlayerSprites = {}

function getPlayerSprites.frente(animationTime, walkingFrame)
  local sprite = assets.marxFrente1
  if math.floor(walkingFrame / animationTime*3) == 1 then
    sprite = assets.marxFrente2
  elseif math.floor(walkingFrame / animationTime*3) == 2 then
    sprite = assets.marxFrente3
  end

  return sprite
end

function getPlayerSprites.costas(animationTime, walkingFrame)
  local sprite = assets.marxCostas1
  if math.floor(walkingFrame / animationTime*3) == 1 then
    sprite = assets.marxCostas2
  elseif math.floor(walkingFrame / animationTime*3) == 2 then
    sprite = assets.marxCostas3
  end

  return sprite
end

function getPlayerSprites.lado(animationTime, walkingFrame)
  local sprite = assets.marxLado1
  if math.floor(walkingFrame / animationTime*3) == 1 then
    sprite = assets.marxLado2
  elseif math.floor(walkingFrame / animationTime*3) == 2 then
    sprite = assets.marxLado3
  end

  return sprite
end

function getPlayerSprites.death(playerDeathFrame, DEATH_TOTAL_TIME)
  local sprite = assets.marxDying1
  if math.floor(playerDeathFrame / DEATH_TOTAL_TIME * 4) == 1 then
    sprite = assets.marxDying2
  elseif math.floor(playerDeathFrame / DEATH_TOTAL_TIME * 4) == 2 then
    sprite = assets.marxDying3
  elseif math.floor(playerDeathFrame / DEATH_TOTAL_TIME * 4) == 3 then
    sprite = assets.marxDying4
  end

  return sprite
end

return getPlayerSprites
