function love.load(arg)
    if arg and arg[#arg] == "-debug" then require("mobdebug").start() end
  

Tycon = {} --Tycon table
  
  Tycon.x = 100 
  Tycon.y = 500
  Tycon.width = 136
  Tycon.height = 70
  Tycon.speed = 300
  Tycon_anim_frame = 1
    
  --score = tonumber(0)
  Tycon.shots = {} -- power ups
  --life = 100
  
  Dinos = {} -- Dino table
  
    for i=1,10 do   -- i = o numero de dino para aparecer
    Dino = {}
    Dino.width = 266
    Dino.height = 131
    Dino.speed = 400
    Dino_anim_frame = 1
            
    Dino.x = (i-1) * (Dino.width + 1150) + math.random(2400,3400) 
    Dino.y = 450
  for x = 1, 8, 1 do
       Dino[x] = love.graphics.newImage("Dino " .. x .. ".png")
  end
    table.insert(Dinos, Dino)
    
    end
  
  for x = 1, 6, 1 do -- frames de Tycon
    Tycon[x] = love.graphics.newImage("Tycon " .. x .. "hd.png")
  end
    
    
  end

song = love.audio.newSource("Tyrun 20.wav", "stream")

anim_Tycon = 1
anim_Dino = 1

vbg = 10 -- velocidade do cenário
ice = 10


gravity = 100 --gravidade em relação a Tycon
jump_height = 190 -- altura do pulo de Tycon

y_velocity = 0 -- velocidade vertical de Tycon

gameover = false

score = 0

gameoverimag = love.graphics.newImage("gameover.png")
playagainimag = love.graphics.newImage("playagain.png")

--[[VARIÁVEIS NÃO UTILIZADAS]]--
d = 0 -- sinal da direção do ciclo dos dias
t = 0 -- direção do ciclo dos dias
speed = 1 -- possível aceleração do cenário(renomear)
cycle = 0 -- valor do ciclo dos dias


function love.update(dt) ---UPDATE  UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE 
  if gameover == false then
  
  local remDino = {}
  for i,v in ipairs(Dinos) do 
    if v.x <= -200 then
      table.insert(remDino, i)
      end
    end
   
   for i,v in ipairs(remDino) do
     table.remove(Dinos, v)     
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
  
  if y_velocity ~= 0 then -- pulo
    Tycon.y = Tycon.y - y_velocity * dt*4 --ajuste da velocidade de subida
    y_velocity = y_velocity - gravity * dt*4 -- ajuste da velocidade de descida
 
    if Tycon.y > 500 then -- parada quando chegar no chão
      y_velocity = 0
      Tycon.y = 500
    end
  end
      
    
  for i,v in ipairs(Dinos) do -- Movimentação dos dinos
    v.x = v.x - dt * math.random(400,800)
    end
  
  
  speed = speed + dt -- possível aceleração para o cenário(renomear)
  --+ (speed/5)
  
  vbg = vbg + dt * (400 + speed/5) -- movimentação do cenário
  
  ice = ice + dt * (400 + speed/5)
  
      
  if vbg >= 1140.011111111111 then -- tempo para o cenário repetir (já está exato)
    vbg = 10 -- valor inicial
  end
  if ice >= 1160.011111111111 then
    ice = 10
    end
  
d = d + dt  -- mudança da variável do sinal da direção do ciclo dos dias (não utilizado)

cycle = cycle + dt * 80 * t -- ciclo dos dias(caso for usado)


if d >= 10 then -- variável que controla o sinal da variável t (não utilizado)
  t = -1
elseif d >= 0 then
  t = 1
  end

if d >= 20 then -- repetição cíclica dos valores de 0 a 20 (não utilizado)
  d = 0
end

for ii,vv in ipairs(Dinos) do
      if CheckCollision(Tycon.x + 65,Tycon.y + 10,40,40,vv.x,vv.y,vv.width - 171, vv.height-100)  or CheckCollision(Tycon.x + 65,Tycon.y + 10,40,40,vv.x + 95,vv.y + 30,vv.width - 165, vv.height - 30)  then
        gameover = true
      
      elseif CheckCollision(Tycon.x + 65,Tycon.y + 10,40,40,vv.x + 100 ,vv.y + 35,vv.width - 40, vv.height-97) then
        y_velocity = 100
     end
 end
 
  
     

function love.draw()
  
 
  --love.graphics.setColor(0 + cycle/2.6,0 + cycle/2.6,255,255)
  if score <= 100 then
  love.graphics.setColor(100,100,255,255) -- luz noturna
  love.graphics.draw(love.graphics.newImage("Floresta.png"), 10 - vbg, 0,0 , 2.1, 2.1 ) -- carrega a Floresta
elseif score <= 2000 then
  love.graphics.setColor(255,255,255,255)
  love.graphics.draw(love.graphics.newImage("Gelo.png"), 10 - ice, 0,0 , 1, 1) -- quando carrega funciona bem mais lento
  end
   
  love.graphics.setColor(255,255,255,255)
  love.graphics.draw(Tycon[Tycon_anim_frame], Tycon.x, Tycon.y, 0, 1, 1) -- animação de Tycon
  
  love.graphics.print(math.floor(score), 700, 50,0,3,3)
  
  

love.graphics.setColor(255,255,255,255)
for i,v in ipairs(Dinos) do
  if v.x <= 850 and v.x >= -200 then
  love.graphics.draw(Dino[Dino_anim_frame], v.x, v.y, 0, 1, 1) -- animação dos Dinos


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

--Hitbox de Tycon
  --[[love.graphics.setColor(0,255,255,190)
    love.graphics.rectangle("fill",Tycon.x + 65,Tycon.y + 10,40,40)]]
    
  
end


elseif gameover == true then -- fim do jogo
  
  
love.audio.stop(song)
function love.draw()
  love.graphics.setColor(100,100,255,255)
  love.graphics.draw(love.graphics.newImage("Floresta.png"), 10 - vbg, 0,0 , 2.1, 2.1 ) --  plano de fundo da tela de 'game over'
  
  love.graphics.setColor(255,255,255)
  love.graphics.print("Score: ".. math.floor(score), 300, 400, 0 , 3, 3) -- pontuação do jogador expressa como arredondamento para o primeiro número inteiro menor que o valor
  
  if gameover == true then
    love.graphics.setColor(255,255,255)
    love.graphics.draw(gameoverimag, 125, 200, 0, 1, 1)
    love.graphics.draw(playagainimag, 275, 300, 0, 1, 1)
  end
end
end
end
function love.keypressed(key, scancode, isrepeat) -- pulo
  if key == " " or key == "space" then
    if y_velocity == 0 then -- Quando Tycon estiver no solo, estará disponível para executar o pulo
      y_velocity = jump_height
    end
  end
  if gameover == true then
   if key == "p" then  -- play again
    gameover = false
    love.load()
    score = 0
   end
  end
end

function CheckCollision(ax1,ay1,aw,ah, bx1,by1,bw,bh)
  local ax2,ay2,bx2,by2 = ax1 + aw, ay1 + ah, bx1 + bw, by1 + bh
  return ax1 < bx2 and ax2 > bx1 and ay1 < by2 and ay2 > by1
end

