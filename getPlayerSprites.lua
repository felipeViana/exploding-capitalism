local getPlayerSprites = {}

function getPlayerSprites.frente()
  sprite = marxFrente1
  if math.floor(walkingFrame / animationTime*3) == 1 then
    sprite = marxFrente2
  elseif math.floor(walkingFrame / animationTime*3) == 2 then
    sprite = marxFrente3
  end

  return sprite
end

function getPlayerSprites.costas()
  sprite = marxCostas1
  if math.floor(walkingFrame / animationTime*3) == 1 then
    sprite = marxCostas2
  elseif math.floor(walkingFrame / animationTime*3) == 2 then
    sprite = marxCostas3
  end

  return sprite
end

function getPlayerSprites.lado()
  sprite = marxLado1
  if math.floor(walkingFrame / animationTime*3) == 1 then
    sprite = marxLado2
  elseif math.floor(walkingFrame / animationTime*3) == 2 then
    sprite = marxLado3
  end

  return sprite
end

function getPlayerSprites.death()
  sprite = marxDying1
  if math.floor(playerDeathFrame / DEATH_TOTAL_TIME * 4) == 1 then
    sprite = marxDying2
  elseif math.floor(playerDeathFrame / DEATH_TOTAL_TIME * 4) == 2 then
    sprite = marxDying3
  elseif math.floor(playerDeathFrame / DEATH_TOTAL_TIME * 4) == 3 then
    sprite = marxDying4
  end

  return sprite
end

return getPlayerSprites
