local getEnemySprites = {}

function getEnemySprites.frente()
  sprite = enemyFrente1
  if math.floor(gameFrame / animationTime*3) == 1 then
    sprite = enemyFrente2
  elseif math.floor(gameFrame / animationTime*3) == 2 then
    sprite = enemyFrente3
  end

  return sprite
end

function getEnemySprites.costas()
  sprite = enemyCostas1
  if math.floor(gameFrame / animationTime*3) == 1 then
    sprite = enemyCostas2
  elseif math.floor(gameFrame / animationTime*3) == 2 then
    sprite = enemyCostas3
  end

  return sprite
end

function getEnemySprites.lado()
  sprite = enemyLado1
  if math.floor(gameFrame / animationTime*3) == 1 then
    sprite = enemyLado2
  elseif math.floor(gameFrame / animationTime*3) == 2 then
    sprite = enemyLado3
  end

  return sprite
end

function getEnemySprites.death()
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

return getEnemySprites
