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

function getBombSprites.exploding()
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

return getBombSprites
