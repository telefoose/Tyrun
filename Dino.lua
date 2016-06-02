local Dino1 = {}

function Dino1.load()
  Dinos = {} -- Dino table
  
  DinoImage = {}
  
  for x = 1, 8, 1 do
    DinoImage[x] = love.graphics.newImage("Dino " .. x .. ".png")
  end
  
end

function Dino1.update(dt)
  if inicio == false then
    if gameover == false then
      local remDino = {}
      for i,v in ipairs(Dinos) do 
        if v.x <= -200 then
          table.insert(remDino, i)
        end
      end
   
      for i,v in ipairs(remDino) do
        table.remove(Dinos, v)
        if score <= 500 then
          if BossMove == 0 then
            table.insert(Dinos, {width = 266, height = 131, speed = love.math.random(350,500), x = (#Dinos-1) * (266 + 1150) + love.math.random(3000,4000), y = 450})
          end
          if BossMove == 1 then
            table.insert(Dinos, {width = 266, height = 131, speed = love.math.random(500,700), x = (#Dinos-1) * (266 + 1150) + love.math.random(3000,4000), y = 450})
          end
        end    
      end 
      
      anim_Dino = anim_Dino + dt * (9 + dt * BossMove * 100) -- velocidade da animação dos Dinos
      if anim_Dino >= 9 then -- repetição da animação dos Dinos
        anim_Dino = 1
      end
      Dino_anim_frame = math.floor(anim_Dino)
      
      if estagio==1 then -- movimentção dos inimigos da primeira fase
        for i,v in ipairs(Dinos) do -- Movimentação dos dinos
          v.x = v.x - dt * v.speed 
        end
      end
    end
  end
end

function Dino1.draw()
  if inicio == false then
    if gameover == false then
      if score >= 120 and score <= 600 then -- Boss1
        love.graphics.setColor(120,120 - (1.2*Boss1Damage),255 - (6*Boss1Damage),255)
        love.graphics.draw(DinoImage[Dino_anim_frame], Boss1.x, Boss1.y, 0, -5, 5)
      end
      
      love.graphics.setColor(255,255,255,255)
      for i,v in ipairs(Dinos) do
        if v.x <= 850 and v.x >= -200 then
          love.graphics.draw(DinoImage[Dino_anim_frame], v.x, v.y, 0, 1, 1) -- animação dos Dinos
        end
      end
    end
  end
  
end

return Dino1