local Yeti1 = {}

function Yeti1.load()
  Yetis = {}
  
  YetiImage = {}
  
  for x = 1, 4, 1 do
    YetiImage[x] = love.graphics.newImage("yeti "..x..".png")
  end
end

function Yeti1.update(dt)
  if inicio == false then
    if gameover == false then
      
      local remYeti = {}
      for i,v in ipairs(Yetis) do
        if v.x <= -100 then
          table.insert(remYeti, i)
        end
      end
      
      for i,v in ipairs(remYeti) do
        table.remove(Yetis, v)
        if score < 1500 then
        table.insert(Yetis, {width = 133, height = 131, speed = love.math.random(350,500), x = (#Yetis-1) * (121 + 1150) + love.math.random(2400,3400), y = 440})
        elseif score >= 1500 and score < 2000 then
        table.insert(Yetis, {width = 133, height = 131, speed = love.math.random(370,520), x = (#Yetis-1) * (121 + 1150) + love.math.random(2400,3400), y = 2000})
      
        yeti_jump = love.math.random(1,10)
        end
      end
      
      anim_Yeti = anim_Yeti + dt * 5  -- velocidade da animação dos Yetis
      if anim_Yeti >= 5 then  -- repetição da animação dos Yetis
        anim_Yeti = 1
      end
      Yeti_anim_frame = math.floor(anim_Yeti)
      
      if estagio == 2 then
        for i,v in ipairs(Yetis) do
          if yeti_velocity ~= 0 then -- pulo dos Yetis
            v.y = v.y - yeti_velocity * dt*4 --ajuste da posição em relação ao eixo y
            yeti_velocity = yeti_velocity - gravity * dt*4 -- ajuste da velocidade em relaçã ao eixo y
 
            if v.y > 440 then -- parada dos Yetis quando chegar no chão
              yeti_velocity = 0
              v.y = 440
            end
          end
        end
        
        for i,v in ipairs(Yetis) do
        v.x = v.x - dt * v.speed      
        end  
      end   
    
    end
  end
end

function Yeti1.draw()
  if inicio == false then
    if gameover == false then
      
      love.graphics.setColor(255, 255, 255, 255)
      if yeti_jump % 2 ~= 0 then
        love.graphics.setColor(255, 240, 255, 255)
      end
      if score >= 1500 and score <= 2000 then -- Boss1
        love.graphics.setColor(120,255,120,255)
        love.graphics.draw(YetiImage[Yeti_anim_frame], Boss2.x, Boss2.y, 0, -3, 3)
      end
      for i,v in ipairs(Yetis) do  -- Imagem dos Yetis
        if v.x <= 850 then
          love.graphics.setColor(255, 255, 255, 255)
          love.graphics.draw(YetiImage[Yeti_anim_frame], v.x, v.y, 0, 1.2, 1.2)
          --love.graphics.setColor(255, 255, 0, 190)
          -- love.graphics.rectangle("fill",v.x,v.y,v.width,v.height)
        end
      end
      
      
    end
  end
end

return Yeti1