--local Player = require "player"

function love.load()

  Tycon = {x = 100, y = 500, width = 136, height = 70, speed = 300, power = 0} --Tycon table
  Tycon_anim_frame = 1
    
  --score = tonumber(0)
  --Tycon.shots = {} -- power ups
  --life = 100
  Flame = {x = Tycon.x + 100, y = Tycon.y, width = 80, height = 80, speed = 300}
  
  Dinos = {} -- Dino table
  
  DinoImage = {}
  
  for x = 1, 8, 1 do
    DinoImage[x] = love.graphics.newImage("Dino " .. x .. ".png")
  end
    
  Boss1 = {x = -300, y = -100, width = 750, height = 550, speed = 100}
    
  Yetis = {}
  
  YetiImage = {}
  
  for x = 1, 4, 1 do
    YetiImage[x] = love.graphics.newImage("yeti "..x..".png")
  end
  
  FlameImage = {}
  for x = 1, 6, 1 do
  FlameImage[x] = love.graphics.newImage("Flame "..x..".png")
end
  
  for x = 1, 6, 1 do -- frames de Tycon
    Tycon[x] = love.graphics.newImage("Tycon " .. x .. "hd.png")
  end
    song = love.audio.newSource("Tyrun 20.wav", "stream")
    Boss1song = love.audio.newSource("Run.wav", "stream")



  play_imag = {imag = love.graphics.newImage("play.png"), x = 310, y = 255}
  gameover_imag = {imag = love.graphics.newImage("gameover.png"), x = 125, y = 200} 
  playagain_imag = {imag = love.graphics.newImage("playagain.png"), x = 275, y = 300}
  
  floresta_imag = love.graphics.newImage("Floresta.png")
  gelo_imag = love.graphics.newImage("Gelo.png")
  

  Tycon_Att = love.graphics.newImage("Tycon Att.png")
  snap_itc_font = love.graphics.newFont("snap.ttf", 50)

  --[[VARIÁVEIS NÃO UTILIZADAS]]--
  d = 0 -- sinal da direção do ciclo dos dias
  t = 0 -- direção do ciclo dos dias
  speed = 1 -- possível aceleração do cenário(renomear)
  cycle = 0 -- valor do ciclo dos dias
  
  reiniciajogo()  -- reinicia o jogo
 
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
    table.insert(Dinos, {width = 266, height = 131, speed = love.math.random(350,500), x = (i-1) * (266 + 1150) + love.math.random(2400,3400), y = 450})
  end
  Yeti_anim_frame = 1
  Flame_anim_frame = 1
  anim_Tycon = 1 -- variável dos frames da animação de Tycon
  anim_Dino = 1 -- variável dos frames da animação dos Dinos
  anim_Yeti = 1-- variável dos frames da animação dos Yetis
  anim_Flame = 1-- variável dos frames da animação das chamas de Tycon
  vbg = 10 -- velocidade do cenário da Floresta com referencial em 10
  ice = 10 -- velocidade do cenário do Gelo com referencial em 10

  score = 0
  BossMove = 0 -- condiciona o campo de batalha contra o primeiro chefe, disponibilizando o power up e a movimentação de Tycon
 yeti_jump = 0 -- Variável que decide se o Yeti pula ou não
 Att = 0 -- variável da posição de ataque de Tycon

  gravity = 100 --gravidade em relação a Tycon
  jump_height = 190 -- altura do pulo de Tycon
  Flame_Travelx = 0 -- componente horizontal da chama
  Flame_Travely = 0 -- componente vertical da chama
  y_velocity = 0 -- velocidade vertical de Tycon
  yeti_velocity = 0 --velocidade vertical dos Yetis

  gameover = false
  inicio = true
  shoot = false
  estagio = 1
end



function love.update(dt) ---UPDATE  UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE 
  if inicio == false then
    if gameover == false then
     Att = Att - dt * 400
     score = score + dt * 20 -- aumento da pontuação através do tempo
     
      if score > 500 and estagio==1 then  -- controle da mudança de fase da Floresta para o Gelo
        while #Dinos>=1 do
          table.remove(Dinos)
        end
        for i=1,1 do
          table.insert(Yetis, {width = 133, height = 131, speed = 300, x = (i-1) * (121 + 1150) + love.math.random(2400,3400), y = 440})
          yeti_jump = love.math.random(1,10)
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
        if score <= 400 then
        table.insert(Dinos, {width = 266, height = 131, speed = love.math.random(350,500), x = (#Dinos-1) * (266 + 1150) + love.math.random(3000,4000), y = 450})
        end
        
        
      end  
      
     
        for i,v in ipairs(Yetis) do
          if v.x <= -100 then
            table.remove(Yetis, i)
            Yetis.y = 440
          table.insert(Yetis, {width = 133, height = 131, speed = 400, x = (#Yetis-1) * (121 + 1150) + love.math.random(2400,3400), y = 440})
          yeti_jump = love.math.random(1,10)
          end
        end
      
      if love.keyboard.isDown("left") or love.keyboard.isDown("a") then -- movimentação horizontal de Tycon
        Tycon.x = Tycon.x - Tycon.speed*dt*0.01 - BossMove * dt *250
      elseif love.keyboard.isDown("right") or love.keyboard.isDown("d")  then
        Tycon.x = Tycon.x + Tycon.speed*dt*0.05 + BossMove * dt *500
      end  
  if score < 120 or score >= 500 then
    love.audio.play(song) -- música do jogo
  end
  if score >= 120 and score < 500 then
  love.audio.stop(song)
end
     
    end
    anim_Tycon = anim_Tycon + dt * (9 + BossMove * 100)-- velocidade da animação de Tycon
    if anim_Tycon >= 7 then -- repetição da animação de Tycon
      anim_Tycon = 1
    end
    Tycon_anim_frame = math.floor(anim_Tycon)
  
    anim_Dino = anim_Dino + dt * (9 + dt * BossMove * 100) -- velocidade da animação dos Dinos
    if anim_Dino >= 9 then -- repetição da animação dos Dinos
      anim_Dino = 1
    end
    Dino_anim_frame = math.floor(anim_Dino)
    
    anim_Yeti = anim_Yeti + dt * 5  -- velocidade da animação dos Yetis
      if anim_Yeti >= 5 then  -- repetição da animação dos Yetis
        anim_Yeti = 1
      end
    Yeti_anim_frame = math.floor(anim_Yeti)
    
    anim_Flame = anim_Flame + dt * 5  -- velocidade da animação dos Yetis
      if anim_Flame >= 7 then  -- repetição da animação dos Yetis
        anim_Flame = 1
      end
    Flame_anim_frame = math.floor(anim_Flame)
    
  
    if y_velocity ~= 0 then -- pulo de Tycon
      Tycon.y = Tycon.y - y_velocity * dt*4 --ajuste da velocidade de subida
      y_velocity = y_velocity - gravity * dt*4 -- ajuste da velocidade de descida
 
      if Tycon.y > 500 then -- parada de Tycon quando chegar no chão
        y_velocity = 0
        Tycon.y = 500
      end
    end
    
    if estagio == 2 then
      BossMove = 0
      shoot = false
    for i,v in ipairs(Yetis) do
    if yeti_velocity ~= 0 then -- pulo dos Yetis
      v.y = v.y - yeti_velocity * dt*4 --ajuste da velocidade de subida
      yeti_velocity = yeti_velocity - gravity * dt*4 -- ajuste da velocidade de descida
 
      if v.y > 440 then -- parada dos Yetis quando chegar no chão
        yeti_velocity = 0
        v.y = 440
      end
      end
    end
    end
    
    if estagio==1 then -- movimentção dos inimigos da primeira fase
      for i,v in ipairs(Dinos) do -- Movimentação dos dinos
        v.x = v.x - dt * (v.speed + BossMove * dt * 50)
      end
      
      if score >= 120 and score<= 500 then  -- música do primiro chefe
        love.audio.play(Boss1song)
        
      if BossMove == 0 then -- Movimentação do Boss1
        Boss1.x = Boss1.x + dt * Boss1.speed 
        if Boss1.x >= 350 then
          BossMove = 1
          power = 1
          end
        
      elseif BossMove == 1 then
        if Tycon.x + 600 > Boss1.x then
        Boss1.x = Boss1.x + dt * Boss1.speed 
        elseif Tycon.x + 600 < Boss1.x then
        Boss1.x = Boss1.x - dt * Boss1.speed
      end
      Flame.x = Flame.x + dt * Flame_Travelx -- Trajetória da Bola de Fogo de Tycon
      Flame.y = Flame.y + dt * Flame_Travely
    end
    end
    
    elseif estagio==2 then -- movimentação dos inimigos da segunda fase
      for i,v in ipairs(Yetis) do
        v.x = v.x - dt * love.math.random(350,500)
        
      end  
    end
  
    speed = speed + dt -- possível aceleração para o cenário(renomear)
  --+ (speed/5)
  
    vbg = vbg + dt * (300 + BossMove * dt * 180)  -- movimentação do cenário
  
    ice = ice + dt * 400
  
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
      for ii,vv in ipairs(Dinos) do  -- Colisão de Tycon com os Dinos
        
        if CheckCollision(Tycon.x + 65,Tycon.y + 10,40,40,vv.x,vv.y,vv.width - 171, vv.height-100)  or CheckCollision(Tycon.x + 65,Tycon.y + 10,40,40,vv.x + 55,vv.y + 30,vv.width - 165, vv.height - 30)  then
          gameover = true
          for i,v in ipairs(Dinos) do
            table.remove(Dinos, i)
          end
      
      elseif CheckCollision(Tycon.x + 65,Tycon.y + 10,40,40,vv.x + 100 ,vv.y + 35,vv.width - 100, vv.height-97) then
        if love.keyboard.isDown("space") or love.keyboard.isDown(" ") then
          y_velocity = 240
          else
          y_velocity = 120
      end
    end
    end
  elseif estagio==2 then  -- Colisão de Tycon com os Yetis
    
      for iii,vvv in ipairs(Yetis) do
        if CheckCollision(Tycon.x + 65,Tycon.y + 10,40,40,vvv.x,vvv.y,vvv.width, vvv.height) then
          gameover = true
    end
  end
  end
    elseif gameover == true then -- fim do jogo
      love.audio.stop(Boss1song)
      love.audio.stop(song)

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
    
      if score <= 500 then
        love.graphics.setColor(100,100,255,255) -- luz noturna
        love.graphics.draw(floresta_imag, 10 - vbg, 0, 0 , 2.1, 2.1 ) -- carrega a Floresta
      elseif score <= 2000 then
        love.graphics.setColor(255,255,255,255)
        love.graphics.draw(gelo_imag, 10 - ice, 0,0 , 2.1, 2.1) -- quando carrega funciona bem mais lento
      end
      
   if score >= 120 and score <= 500 then -- Boss1
      love.graphics.draw(DinoImage[Dino_anim_frame], Boss1.x, Boss1.y, 0, -5, 5)
    end
   if shoot == true then
    love.graphics.setColor(255,255,255,255) -- bola de fogo de Tycon FOGO
    love.graphics.draw(FlameImage[Flame_anim_frame], Flame.x,Flame.y,0,0.4,0.4,40,40)
    end
    
      love.graphics.setColor(255,255,255,255)
      if Att <= 0 then
      love.graphics.draw(Tycon[Tycon_anim_frame], Tycon.x, Tycon.y, 0, 1, 1) -- animação de Tycon
    elseif Att > 0 then
      love.graphics.draw(Tycon_Att, Tycon.x + 20, Tycon.y - 20, 0, 1, 1)
      end
      love.graphics.setColor(0,255,255,190)
      love.graphics.rectangle("fill",Tycon.x + 65,Tycon.y + 10,40,40)
  
      love.graphics.setColor(255,255,255)
      love.graphics.setFont(snap_itc_font)
      love.graphics.print(math.floor(score), 650, 50,0,1,1) -- pontuação do jogador
      
      
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
  --[[love.graphics.setColor(255,0,0,190)
love.graphics.rectangle("fill",v.x,v.y,v.width - 171, v.height-100)
love.graphics.rectangle("fill",v.x + 55,v.y + 30,v.width - 165, v.height - 30)

love.graphics.setColor(255,0,255,190)
love.graphics.rectangle("fill",v.x + 100 ,v.y + 35,v.width - 100, v.height-97)
end]]
        end
      end
      
      
      love.graphics.setColor(255, 255, 255, 255)
      if yeti_jump % 2 ~= 0 then
        love.graphics.setColor(255, 240, 255, 255)
        end
      for i,v in ipairs(Yetis) do  -- Imagem dos Yetis
        if v.x <= 850 then
          love.graphics.draw(YetiImage[Yeti_anim_frame], v.x, v.y, 0, 1.2, 1.2)
          --love.graphics.setColor(255, 255, 0, 190)
            -- love.graphics.rectangle("fill",v.x,v.y,v.width,v.height)
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
    
      if estagio == 2 and yeti_velocity==0  then
        
        if yeti_jump == 1 or  yeti_jump == 3 or  yeti_jump == 5 or  yeti_jump == 7 then
        yeti_velocity = jump_height*1.333
    end
  end
  end
  if key == "return" and (inicio == true) then
    inicio = false
      gameover = false
      score = 0
    end
    if  key == "return" and gameover == true then
  reiniciajogo()
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
  if gameover == false and BossMove == 1 then
    if button == "l" and y < 450 then
      shoot = true
      Att = 100
      Flame_Travelx = x - Tycon.x + 100
      Flame_Travely = y - Tycon.y
      if Flame.x >= 850 or Flame.y <= -50 then
        Flame.x = Tycon.x + 100
        Flame.y = Tycon.y
end
end
end
end

function CheckCollision(ax1,ay1,aw,ah, bx1,by1,bw,bh)
  local ax2,ay2,bx2,by2 = ax1 + aw, ay1 + ah, bx1 + bw, by1 + bh
  return ax1 < bx2 and ax2 > bx1 and ay1 < by2 and ay2 > by1
end

