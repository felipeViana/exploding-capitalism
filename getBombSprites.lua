local assets = require "assets"

local getBombSprites = {}

function getBombSprites.exists(animationTime, bombFrame)
  local sprite = assets.bomb1
  if math.floor(bombFrame / animationTime*4) == 1 then
    sprite = assets.bomb2
  elseif math.floor(bombFrame / animationTime*4) == 2 then
    sprite = assets.bomb3
  elseif math.floor(bombFrame / animationTime*4) == 3 then
    sprite = assets.bomb2
  end

  return sprite
end

local function explodingCenter(animationTime, bombFrame)
  local sprite = assets.explosionCenter1
  if math.floor(bombFrame / animationTime*4) == 1 then
    sprite = assets.explosionCenter2
  elseif math.floor(bombFrame / animationTime*4) == 2 then
    sprite = assets.explosionCenter3
  elseif math.floor(bombFrame / animationTime*4) == 3 then
    sprite = assets.explosionCenter4
  end

  return sprite
end

function getBombSprites.byIndex(index, animationTime, bombFrame)
  if index == 0 then
    return explodingCenter(animationTime, bombFrame)
  elseif index == 1 or index == -1 then
    return assets.explosionMiddle
  elseif index == 2 or index == -2 then
    return assets.explosionMiddleTail
  elseif index == 3 or index == -3 then
    return assets.explosionTail
  end
end

return getBombSprites
