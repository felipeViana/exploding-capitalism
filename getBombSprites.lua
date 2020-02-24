local getBombSprites = {}

function getBombSprites.exists()
  sprite = bomb1
  if math.floor(bombFrame / animationTime*4) == 1 then
    sprite = bomb2
  elseif math.floor(bombFrame / animationTime*4) == 2 then
    sprite = bomb3
  elseif math.floor(bombFrame / animationTime*4) == 3 then
    sprite = bomb2
  end

  return sprite
end

function getBombSprites.explodingCenter()
  sprite = explosionCenter1
  if math.floor(bombFrame / animationTime*4) == 1 then
    sprite = explosionCenter2
  elseif math.floor(bombFrame / animationTime*4) == 2 then
    sprite = explosionCenter3
  elseif math.floor(bombFrame / animationTime*4) == 3 then
    sprite = explosionCenter4
  end

  return sprite
end

function getBombSprites.byIndex(index)
  if index == 0 then
    return getBombSprites.explodingCenter()
  elseif index == 1 or index == -1 then
    return explosionMiddle
  elseif index == 2 or index == -2 then
    return explosionMiddleTail
  elseif index == 3 or index == -3 then
    return explosionTail
  end
end

return getBombSprites
