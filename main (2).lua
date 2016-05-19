function love.load()

  Tycon = {x = 100, y = 500, width = 136, height = 70, speed = 300} --Tycon table
  Tycon_anim_frame = 1
    
  --score = tonumber(0)
  Tycon.shots = {} -- power ups
  --life = 100
  
  Dinos = {} -- Dino table
  
  DinoImage = {}
  
  for x = 1, 8, 1 do
    DinoImage[x] = love.graphics.newImage("Dino " .. x .. ".png")
  end
  
  
  Yetis = {}
  
  YetiImage = {}
  
  for x = 1, 4, 1 do
    YetiImage[x] = love.graphics.newImage("yeti "..x..".png")
  end
  
  
  for x = 1, 6, 1 do -- frames de Tycon
    Tycon[x] = love.graphics.newImage("Tycon " .. x .. "hd.png")
  end
    song = love.audio.newSource("Tyrun 20.wav", "stream")



  play_imag = {imag = love.graphics.newImage("play.png"), x = 310, y = 255}
  gameover_imag = {imag = love.graphics.newImage("gameover.png"), x = 125, y = 200} 
  playagain_imag = {imag = love.graphics.newImage("playagain.png"), x = 275, y = 300}
  
  floresta_imag = love.graphics.newImage("Floresta.png")
  gelo_imag = love.graphics.newImage("Gelo.png")

  snap_itc_font = love.graphics.newFont("snap.ttf", 50)

  --[[VARIÁVEIS NÃO UTILIZADAS]]--
  d = 0 -- sinal da direção do ciclo dos dias
  t = 0 -- direção do ciclo dos dias
  speed = 1 -- possível aceleração do cenário(renomear)
  cycle = 0 -- valor do ciclo dos dias
  
  reiniciajogo()
 
end

function reiniciajogo()
  while #Dinos>=1 do
    table.remove(Dinos,1)
  end
  while #Yetis>=1 do
    table.remove(Yetis,1)
  end
  Tycon.y=500
  for i=1,3 do   -- i = o numero de dino para aparecer
    Dino_anim_frame = 1
    table.insert(Dinos, {width = 266, height = 131, speed = 400, x = (i-1) * (266 + 1150) + love.math.random(2400,3400), y = 450})
  end
  Yeti_anim_frame = 1
  anim_Tycon = 1
  anim_Dino = 1
  anim_Yeti = 1

  vbg = 10 -- velocidade do cenário
  ice = 10

  score = 0
 

  gravity = 100 --gravidade em relação a Tycon
  jump_height = 190 -- altura do pulo de Tycon

  y_velocity = 0 -- velocidade vertical de Tycon

  gameover = false
  inicio = true
  estagio = 1
end



function love.update(dt) ---UPDATE  UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE 
  if inicio == false then
    if gameover == false then
      
      
      
      if score > 100 and estagio==1 then
        while #Dinos>=1 do
          table.remove(Dinos)
        end
        for i=1,3 do
          table.insert(Yetis, {width = 266, height = 131, speed = 300, x = (i-1) * (121 + 1150) + love.math.random(2400,3400), y = 465})
        end
        estagio = 2
      end     
  
      local remDino = {}
      for i,v in ipairs(Dinos) do 
        if v.x <= -200 then
          table.insert(remDino, i)
        end
      end
   
      for i,v in ipairs(remDino) do
        table.remove(Dinos, v)
        table.insert(Dinos, {width = 266, height = 131, speed = 400, x = (#Dinos-1) * (266 + 1150) + love.math.random(2400,3400), y = 450})
      end  
      
      local remYeti = {}
        for i,v in ipairs(Yetis) do
          if v.x <= -50 then
            table.insert(remYeti, i)
          end
        end
      
        for i,v in ipairs(remYeti) do
          table.remove(Yetis, v)
          table.insert(Yetis, {width = 266, height = 131, speed = 400, x = (#Yetis-1) * (121 + 1150) + love.math.random(2400,3400), y = 465})
        end
  
      if love.keyboard.isDown("left") or love.keyboard.isDown("a") then -- movimentação horizontal de Tycon
        Tycon.x = Tycon.x - Tycon.speed*dt*0.01
      elseif love.keyboard.isDown("right") or love.keyboard.isDown("d")  then
        Tycon.x = Tycon.x + Tycon.speed*dt*0.05
      end  
  
    love.audio.play(song)
  
    score = score + dt * 2
  
    anim_Tycon = anim_Tycon + dt * 9
    if anim_Tycon >= 7 then
      anim_Tycon = 1
    end
    Tycon_anim_frame = math.floor(anim_Tycon)
  
    anim_Dino = anim_Dino + dt * 9
    if anim_Dino >= 9 then
      anim_Dino = 1
    end
    Dino_anim_frame = math.floor(anim_Dino)
    
    anim_Yeti = anim_Yeti + dt * 9
      if anim_Yeti >= 4 then
        anim_Yeti = 1
      end
    Yeti_anim_frame = math.floor(anim_Yeti)
  
    if y_velocity ~= 0 then -- pulo
      Tycon.y = Tycon.y - y_velocity * dt*4 --ajuste da velocidade de subida
      y_velocity = y_velocity - gravity * dt*4 -- ajuste da velocidade de descida
 
      if Tycon.y > 500 then -- parada quando chegar no chão
        y_velocity = 0
        Tycon.y = 500
      end
    end
      
    if estagio==1 then
      for i,v in ipairs(Dinos) do -- Movimentação dos dinos
        v.x = v.x - dt * love.math.random(400,800)
      end
    
    elseif estagio==2 then
      for i,v in ipairs(Yetis) do
        v.x = v.x - dt * love.math.random(350,750)
      end  
    end
  
    speed = speed + dt -- possível aceleração para o cenário(renomear)
  --+ (speed/5)
  
    vbg = vbg + dt * (400) -- movimentação do cenário
  
    ice = ice + dt * (400)
  
    if estagio==1 then  
      if vbg >= 1140.011111111111 then -- tempo para o cenário repetir (já está exato)
        vbg = 10 -- valor inicial
      end
    elseif estagio==2 then
      if ice >= 920.011111111111 then
        ice = 10
      end
    end
  
   --[[ d = d + dt  -- mudança da variável do sinal da direção do ciclo dos dias (não utilizado)

    cycle = cycle + dt * 80 * t -- ciclo dos dias(caso for usado)


    if d >= 10 then -- variável que controla o sinal da variável t (não utilizado)
      t = -1
    elseif d >= 0 then
      t = 1
    end

    if d >= 20 then -- repetição cíclica dos valores de 0 a 20 (não utilizado)
      d = 0
    end]]--
    if estagio==1 then
      for ii,vv in ipairs(Dinos) do
        if CheckCollision(Tycon.x + 65,Tycon.y + 10,40,40,vv.x,vv.y,vv.width - 171, vv.height-100)  or CheckCollision(Tycon.x + 65,Tycon.y + 10,40,40,vv.x + 95,vv.y + 30,vv.width - 165, vv.height - 30)  then
          gameover = true
          for i,v in ipairs(Dinos) do
            table.remove(Dinos, i)
          end
      
        elseif CheckCollision(Tycon.x + 65,Tycon.y + 10,40,40,vv.x + 100 ,vv.y + 35,vv.width - 40, vv.height-97) then
          y_velocity = 100
      end
    end
    elseif estagio==2 then
      for ii,vv in ipairs(Yetis) do
        if CheckCollision(Tycon.x + 65,Tycon.y + 10,40,40,vv.x,vv.y,vv.width - 171, vv.height-100) then
          gameover = true
    end
  end
  end
    elseif gameover == true then -- fim do jogo
  
  
      love.audio.stop(song)

    end
  end
end

function love.draw()
  if inicio == true then -- tela inicial
    
      love.graphics.setColor(100,100,255,255)
      love.graphics.draw(floresta_imag, 10 - vbg, 0,0 , 2.1, 2.1 )
      
      love.graphics.setColor(255, 255, 255)
      love.graphics.draw(play_imag.imag, play_imag.x, play_imag.y, 0 , 1, 1)
    
  elseif inicio == false then
    
    if gameover == false then
    
      if score <= 100 then
        love.graphics.setColor(100,100,255,255) -- luz noturna
        love.graphics.draw(floresta_imag, 10 - vbg, 0, 0 , 2.1, 2.1 ) -- carrega a Floresta
      elseif score <= 2000 then
        love.graphics.setColor(255,255,255,255)
        love.graphics.draw(gelo_imag, 10 - ice, 0,0 , 2.1, 2.1) -- quando carrega funciona bem mais lento
      end
   
      love.graphics.setColor(255,255,255,255)
      love.graphics.draw(Tycon[Tycon_anim_frame], Tycon.x, Tycon.y, 0, 1, 1) -- animação de Tycon
  
      love.graphics.setColor(255,255,255)
      love.graphics.setFont(snap_itc_font)
      love.graphics.print(math.floor(score), 650, 50,0,1,1)
      
      
       love.graphics.setColor(255, 255, 255)
      love.graphics.setFont(snap_itc_font)
      love.graphics.print(#Dinos, 400, 100, 0, 1, 1)
      
      love.graphics.setColor(255, 255, 255)
      love.graphics.setFont(snap_itc_font)
      love.graphics.print(#Yetis, 400, 300, 0, 1, 1)
  
  
      love.graphics.setColor(255,255,255,255)
      for i,v in ipairs(Dinos) do
        if v.x <= 850 and v.x >= -200 then
          love.graphics.draw(DinoImage[Dino_anim_frame], v.x, v.y, 0, 1, 1) -- animação dos Dinos


--Hitbox dos Dinos
--[[for ii,vv in ipairs(Dinos) do
  love.graphics.setColor(255,0,0,190)
love.graphics.rectangle("fill",vv.x,vv.y,vv.width - 171, vv.height-100)
love.graphics.rectangle("fill",vv.x + 95,vv.y + 30,vv.width - 165, vv.height - 30)

love.graphics.setColor(255,0,255,190)
love.graphics.rectangle("fill",vv.x + 100 ,vv.y + 35,vv.width - 40, vv.height-97)
end]]

        end
      end
      
      love.graphics.setColor(255, 255, 255, 255)
      for i,v in ipairs(Yetis) do
        if v.x <= 850 then
          love.graphics.draw(YetiImage[Yeti_anim_frame], v.x, v.y, 0, 1.2, 1.2)
        end
      end
    


    elseif gameover == true then -- fim do jogo
  
      love.graphics.setColor(100,100,255,255)
      love.graphics.draw(floresta_imag, 10 - vbg, 0,0 , 2.1, 2.1 ) --  plano de fundo da tela de 'game over'
  
      love.graphics.setColor(255,255,255)
      love.graphics.setFont(snap_itc_font)
      love.graphics.print("Score: ".. math.floor(score), 300, 400, 0 , 1, 1) -- pontuação do jogador expressa como arredondamento para o primeiro número inteiro menor que o valor
  
      
        love.graphics.setColor(255,255,255)
        love.graphics.draw(gameover_imag.imag, gameover_imag.x, gameover_imag.y, 0, 1, 1)
        love.graphics.draw(playagain_imag.imag, playagain_imag.x, playagain_imag.y, 0, 1, 1)
     

    end
  end
end
  
  
  
  
  
  
function love.keypressed(key, scancode, isrepeat) -- pulo
  if key == " " or key == "space" then
    if y_velocity == 0 then -- Quando Tycon estiver no solo, estará disponível para executar o pulo
      y_velocity = jump_height
    end
  end
end

function love.mousepressed(x, y, button)
  if inicio == true then
    if button == "l" and x > play_imag.x and x < play_imag.x + play_imag.imag:getWidth() and y > play_imag.y and y < play_imag.y + play_imag.imag:getHeight() then
      inicio = false
      gameover = false
      score = 0
    end
  end
  if gameover == true then
    if button == "l" and x > playagain_imag.x and x < playagain_imag.x + playagain_imag.imag:getWidth() and y > playagain_imag.y and y < playagain_imag.y + playagain_imag.imag:getHeight() then
      reiniciajogo()
    end
  end
end

function CheckCollision(ax1,ay1,aw,ah, bx1,by1,bw,bh)
  local ax2,ay2,bx2,by2 = ax1 + aw, ay1 + ah, bx1 + bw, by1 + bh
  return ax1 < bx2 and ax2 > bx1 and ay1 < by2 and ay2 > by1
end

