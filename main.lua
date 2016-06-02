Tycon1 = require "Tycon"
Dino1 = require "Dino"
Yeti1 = require "Yeti"

function CheckCollision(ax1,ay1,aw,ah, bx1,by1,bw,bh)
  local ax2,ay2,bx2,by2 = ax1 + aw, ay1 + ah, bx1 + bw, by1 + bh
  return ax1 < bx2 and ax2 > bx1 and ay1 < by2 and ay2 > by1
end

function love.load(arg)
  if arg and arg[#arg] == "-debug" then require("mobdebug").start() end
Tycon1.load()
Dino1.load()
Yeti1.load()
    
  --score = tonumber(0)
  --Tycon.shots = {} -- power ups
  --life = 100
     
  Boss1 = {x = -300, y = -100, width = 750, height = 550, speed = 100,HP = 100}
  Boss2 = {x = 700, y = 245, width = 750, height = 550, speed = 100,HP = 250}
    
  stage1song = love.audio.newSource("Tyrun 20.wav", "stream")
    
  Boss1song = love.audio.newSource("Run.wav", "stream")
  --FlameEffect = love.audio.newSource("Flame.mp3", "static")

  play_imag = {imag = love.graphics.newImage("play.png"), x = 310, y = 255}
  gameover_imag = {imag = love.graphics.newImage("gameover.png"), x = 125, y = 200} 
  playagain_imag = {imag = love.graphics.newImage("playagain.png"), x = 275, y = 300}
  
  floresta_imag = love.graphics.newImage("Floresta.png")
  gelo_imag = love.graphics.newImage("Gelo.png")
  fire_imag = love.graphics.newImage("Fire.png")
  
  Tycon_Att = love.graphics.newImage("Tycon Att.png")
  snap_itc_font = love.graphics.newFont("snap.ttf", 50)
  
  MouseClick_anim_frame = 1
  
  MouseClick = {}
  for x = 1, 2, 1 do -- frames do MouseClick
    MouseClick[x] = love.graphics.newImage("MouseClick " .. x .. ".png")
  end
  

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
  for i=1,3 do   -- i = o numero de dino para aparecer
    Dino_anim_frame = 1
    table.insert(Dinos, {width = 266, height = 131, speed = love.math.random(350,500), x = (i-1) * (266 + 1150) + love.math.random(2400,3400), y = 450})
  end
  Tycon.x = 100
  Tycon.y = 500
  Tycon.power = 0
  Boss1.x = -300
  Boss2.x = 700
  Yeti_anim_frame = 1
  Flame_anim_frame = 1
  MouseClick_anim_frame = 1
  anim_MouseClick = 1
  anim_Tycon = 1 -- variável dos frames da animação de Tycon
  anim_Dino = 1 -- variável dos frames da animação dos Dinos
  anim_Yeti = 1-- variável dos frames da animação dos Yetis
  anim_Flame = 1-- variável dos frames da animação das chamas de Tycon
  vbg = 10 -- velocidade do cenário da Floresta com referencial em 10
  ice = 10 -- velocidade do cenário do Gelo com referencial em 10
  fire = 10

  score = 0
  BossMove = 0 -- condiciona o campo de batalha contra o primeiro chefe, disponibilizando o power up e a movimentação de Tycon
  yeti_jump = 0 -- Variável que decide se o Yeti pula ou não
  Att = 0 -- variável da posição de ataque de Tycon
  Click = false

  gravity = 100 --gravidade em relação a todos os objetos afetados
  jump_height = 190 -- altura do pulo de Tycon
  Flame_Travelx = 0 -- componente horizontal da chama
  Flame_Travely = 0 -- componente vertical da chama
  y_velocity = 0 -- velocidade vertical de Tycon
  yeti_velocity = 0 --velocidade vertical dos Yetis
  
  Boss1Damage = 0

  gameover = false
  inicio = true
  shoot = false
  vextraX = 0
  estagio = 1
end

function love.update(dt) ---UPDATE  UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE 
  
  vbg = vbg + dt * (300 + BossMove * 8 * Boss1Damage)  -- movimentação do cenário
 
  ice = ice + dt * 400
   
  fire = fire + dt * 500
   
  if vbg >= 1140.011111111111 then -- tempo para o cenário 1 repetir (já está exato)
    vbg = 10 -- valor inicial
  end
   
  if ice >= 920.011111111111 then -- tempo para o cenário 2 repetir (já está exato)
    ice = 10
  end
   
  if fire >= 1910.011111111111 then
    fire = 10
  end
     
  Tycon1.update(dt)
  Dino1.update(dt)
  Yeti1.update(dt)
  if inicio == false then
    if gameover == false then
      Att = Att - dt * 400
      score = score + dt * 90 -- aumento da pontuação através do tempo
    
      if score > 600 and estagio==1 then  -- controle da mudança de fase da Floresta para o Gelo
        while #Dinos>=1 do
          table.remove(Dinos)
        end
        for i=1,1 do
          table.insert(Yetis, {width = 133, height = 131, speed = 300, x = (i-1) * (121 + 1150) + love.math.random(2400,3400), y = 440})
          yeti_jump = love.math.random(1,10)
        end
        Tycon.x = 100
        estagio = 2
      elseif score > 2000 and estagio==2 then
        while #Yetis>=1 do
          table.remove(Yetis)
        end
        Tycon.x = 100
        estagio = 3
      end           
 
     --[[if love.keyboard.isDown("left") or love.keyboard.isDown("a") then -- movimentação horizontal de Tycon
      vextraX = -0.3
      Tycon.x = Tycon.x - Tycon.speed*dt*0.1 - BossMove * dt * Tycon.speed*5/6
     elseif love.keyboard.isDown("right") or love.keyboard.isDown("d")  then
       vextraX = 1
       Tycon.x = Tycon.x + Tycon.speed*dt*0.15 + BossMove * dt * Tycon.speed*5/3
     else
       vextraX = 0
     end]]  
     
      if score < 120 or score >= 600 then
        love.audio.play(stage1song) -- música do jogo
      end
      if score >= 120 and score < 600 then
        love.audio.stop(stage1song)
      end   
      
      if estagio == 2 then
        love.audio.stop(Boss1song)
        love.audio.play(stage1song)
        shoot = false 
        if score <= 1500 then
         BossMove = 0
         else
          BossMove = 2
        end
        
            
      end
    
      if estagio==1 then -- movimentção dos inimigos da primeira fase
           
        if score >= 120 and score<= 600 then  -- música do primiro chefe
          love.audio.play(Boss1song)
        
          if BossMove == 0 then -- Movimentação do Boss1
            Boss1.x = Boss1.x + dt * Boss1.speed 
            if Boss1.x >= 350 then
              BossMove = 1
              power = 1
            end
        
          elseif BossMove == 1 then -- trajetória perseguidora do Boss1
            if Tycon.x + 600 > Boss1.x then
              Boss1.x = Boss1.x + dt * Boss1.speed 
            elseif Tycon.x + 600 < Boss1.x then
              Boss1.x = Boss1.x - dt * Boss1.speed
            end
            if shoot == true then
              if Flame_Travelx >= 0 and Flame_Travelx < 10 and Flame_Travely <= 0 and Flame_Travely > -10 then
                Flame.x = Flame.x + dt * Flame_Travelx *1.5 * 100 -- Trajetória da Bola de Fogo de Tycon no eixo x
                Flame.y = Flame.y + dt * Flame_Travely *1.5 * 100-- Trajetória da Bola de Fogo de Tycon no eixo y
              elseif Flame_Travelx >= 10 and Flame_Travelx < 100 and Flame_Travely <= -10 and Flame_Travely > -100 then
                Flame.x = Flame.x + dt * Flame_Travelx *1.5 * 10 -- Trajetória da Bola de Fogo de Tycon no eixo x
                Flame.y = Flame.y + dt * Flame_Travely *1.5 * 10-- Trajetória da Bola de Fogo de Tycon no eixo y
              else
                Flame.x = Flame.x + dt * Flame_Travelx *1.5 -- Trajetória da Bola de Fogo de Tycon no eixo x
                Flame.y = Flame.y + dt * Flame_Travely *1.5 -- Trajetória da Bola de Fogo de Tycon no eixo y
              end
            end
  
            if Flame.x >= 850 or Flame.y <= -50 then
              shoot = false
            end
            if shoot == false then
              Flame.x = Tycon.x + 70
              Flame.y = Tycon.y - 20
            end
          end      
        end
      end
      
      speed = speed + dt -- possível aceleração para o cenário(renomear)
      --+ (speed/5)      
      if score >= 120 and score <= 600  and Tycon.power ~= 1 then
        Click = true
      end
      
      
      anim_MouseClick = anim_MouseClick + dt * 5  
      if anim_MouseClick >= 3 then  
         anim_MouseClick = 1
      end
      MouseClick_anim_frame = math.floor(anim_MouseClick)
      end
      
      if score >= 580 and BossMove == 1 then
        score = 200
      end
      if score >= 1980 and BossMove == 2 then
        score = 1600
      end
    
    
    if Boss1Damage == 50 then 
      BossMove = 0
      score = 600
      Boss1Damage = 51
    end
   
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
        
    if CheckCollision(Flame.x+30,Flame.y-40,Flame.width,Flame.height,Boss1.x - 400,Boss1.y,Boss1.width - 330,Boss1.height - 350) then -- Colisão da bola de fogo com o primeiro chefe
      Boss1Damage = Boss1Damage + 1
      shoot = false
    end
  
    for iii,vvv in ipairs(Yetis) do -- Colisão de Tycon com os Yetis
      if CheckCollision(Tycon.x + 65,Tycon.y + 10,40,40,vvv.x,vvv.y,vvv.width, vvv.height) then
        gameover = true
      end
    end
  
    if gameover == true then -- fim do jogo
      love.audio.stop(Boss1song)
      love.audio.stop(stage1song)
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
    
      if score <= 600 then
        love.graphics.setColor(100,100,255,255) -- luz noturna
        love.graphics.draw(floresta_imag, 10 - vbg, 0, 0 , 2.1, 2.1 ) -- carrega a Floresta
      elseif score <= 2000 then
        love.graphics.setColor(255,255,255,255)
        love.graphics.draw(gelo_imag, 10 - ice, 0, 0 , 2.1, 2.1) -- quando carrega funciona bem mais lento
      elseif score > 2000 then
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.draw(fire_imag, 10 - fire, 0, 0, 2.0, 2.0)
      end
                       
      -- love.graphics.setColor(255,0,0,190)
      -- love.graphics.rectangle("fill",Boss1.x - 350,Boss1.y,(-1)*Boss1.width+400,Boss1.height - 170)
      --love.graphics.setColor(0,255,0,190)
      --love.graphics.rectangle("fill",Boss1.x - 400,Boss1.y,Boss1.width - 330,Boss1.height - 350)
          
      Dino1.draw()
      Tycon1.draw()
      Yeti1.draw()
      
      love.graphics.setColor(120,120,120,180) -- item BOX
      love.graphics.rectangle("fill",20,20,80,80)
      love.graphics.setColor(0,0,0,255)
      love.graphics.setLineWidth(3)
      love.graphics.line(20,20,100,20,100,100,20,100,20,20)
      
      if Click == true then
      love.graphics.setColor(255,255,255,255)
      love.graphics.draw(MouseClick[MouseClick_anim_frame], 20,20, 0, 1, 1)
      end
      love.graphics.setColor(255,255,255)
      love.graphics.setFont(snap_itc_font)
      love.graphics.print(math.floor(score), 650, 50,0,1,1) -- pontuação do jogador
           
      --love.graphics.setColor(255, 255, 255)
      --love.graphics.setFont(snap_itc_font)
      --love.graphics.print(#Dinos, 400, 100, 0, 1, 1)
      
      --love.graphics.setColor(255, 255, 255)
      --love.graphics.setFont(snap_itc_font)
      --love.graphics.print(#Yetis, 400, 300, 0, 1, 1)
      
      --love.graphics.setColor(255, 255, 255)
      --love.graphics.setFont(snap_itc_font)
      --love.graphics.print(Boss1Damage, 400, 300, 0, 1, 1)
      
      -- love.graphics.setColor(255, 255, 255)
      --love.graphics.setFont(snap_itc_font)
      --love.graphics.print(vextraX, 400, 50, 0, 1, 1)
          
      --Hitbox dos Dinos
      --[[love.graphics.setColor(255,0,0,190)
      love.graphics.rectangle("fill",v.x,v.y,v.width - 171, v.height-100)
      love.graphics.rectangle("fill",v.x + 55,v.y + 30,v.width - 165, v.height - 30)

      love.graphics.setColor(255,0,255,190)
      love.graphics.rectangle("fill",v.x + 100 ,v.y + 35,v.width - 100, v.height-97)]]
       
    elseif gameover == true then -- fim do jogo
      
      love.graphics.setColor(100,100,255,255)
      love.graphics.draw(floresta_imag, 10 - vbg, 0,0 , 2.1, 2.1 ) --  plano de fundo da tela de 'game over'
  
      love.graphics.setColor(255,255,255)
      love.graphics.setFont(snap_itc_font)
      love.graphics.print("Score: ".. math.floor(score), 250, 400, 0 , 1, 1) -- pontuação do jogador expressa como arredondamento para o primeiro número inteiro menor que o valor
       
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
    if button == 1 and x > play_imag.x and x < play_imag.x + play_imag.imag:getWidth() and y > play_imag.y and y < play_imag.y + play_imag.imag:getHeight() then
      inicio = false
      gameover = false
      score = 0
    end
  end
  if gameover == true then
    if button == 1 and x > playagain_imag.x and x < playagain_imag.x + playagain_imag.imag:getWidth() and y > playagain_imag.y and y < playagain_imag.y + playagain_imag.imag:getHeight() then
      reiniciajogo()
    end
  end
  if gameover == false and BossMove == 1 then
    if button == 1 and y < 450 and x > Tycon.x + 130 and Flame.x == Tycon.x + 70 then
      shoot = true
      Tycon.power = 1
      Click = false
      --love.audio.play(FlameEffect)
      Att = 100 -- tempo inicial da duração do ataque d Tycon
      Flame_Travelx = x - Tycon.x + 70 + vextraX * Tycon.speed*5/3
      Flame_Travely = y - Tycon.y - 20      
    end
  end
end



