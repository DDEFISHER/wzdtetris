--block globals
blocks = {}
inactive_blocks = {}
bit1_img = nil
bit2_img = nil
bit3_img = nil
bit4_img = nil
bit5_img = nil
bit6_img = nil
bit7_img = nil
block_timer = 0
active_block = 1

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end
function no_bottom(block)

  for k, bit in ipairs(block) do
    
    if (bit.y + bit.img:getHeight( ) >= 750) then
      return false
    end
  end

  return true

end

function create_block()

    local bits = {}
    --local random_position = math.random(10, love.graphics.getWidth() - 100)
    local random_position = 256
    local random_block = math.random(7)

    local x1
    local x2
    local x3
    local x4

    local y1
    local y2
    local y3
    local y4

    local random_block_img

    if random_block == 1 then
      x1 = random_position
      x2 = random_position + 32
      x3 = random_position + 64 
      x4 = random_position + 96

      y1 = -100
      y2 = -100
      y3 = -100
      y4 = -100

      random_block_img = bit1_img
    elseif random_block == 2 then

      x1 = random_position
      x2 = random_position + 32
      x3 = random_position 
      x4 = random_position + 32

      y1 = -100
      y2 = -100
      y3 = -132
      y4 = -132

      random_block_img = bit2_img
    elseif random_block == 3 then

      x1 = random_position
      x2 = random_position + 32
      x3 = random_position + 64
      x4 = random_position + 64

      y1 = -100
      y2 = -100
      y3 = -100
      y4 = -132

      random_block_img = bit3_img
    elseif random_block == 4 then

      x1 = random_position
      x2 = random_position + 32
      x3 = random_position + 64
      x4 = random_position + 64

      y1 = -100
      y2 = -100
      y3 = -100
      y4 = -68

      random_block_img = bit4_img
    elseif random_block == 5 then

      x1 = random_position
      x2 = random_position + 32
      x3 = random_position + 32 
      x4 = random_position + 64

      y1 = -100
      y2 = -100
      y3 = -132
      y4 = -132

      random_block_img = bit5_img
    elseif random_block == 6 then

      x1 = random_position
      x2 = random_position + 32
      x3 = random_position + 32 
      x4 = random_position + 64

      y1 = -100
      y2 = -100
      y3 = -68
      y4 = -68

      random_block_img = bit6_img
    elseif random_block == 7 then

      x1 = random_position
      x2 = random_position + 32
      x3 = random_position + 64 
      x4 = random_position + 32

      y1 = -100
      y2 = -100
      y3 = -100
      y4 = -132

      random_block_img = bit7_img
    end

    local new_bit = { x = x1, y = y1, img = random_block_img}
    table.insert(bits,new_bit)
    new_bit = { x = x2, y = y2, img = random_block_img}
    table.insert(bits,new_bit)
    new_bit = { x = x3, y = y3, img = random_block_img}
    table.insert(bits,new_bit)
    new_bit = { x = x4, y = y4, img = random_block_img}
    table.insert(bits,new_bit)

    table.insert(blocks, bits)

    block_timer = 0

end
function check_block_collision(block1,block2,no_collision)

      --must check each bit in block1 with each bit in block2
      for i, bit1 in ipairs(block1) do
        for k, bit2 in ipairs(block2) do

          if CheckCollision(bit1.x,bit1.y,bit1.img:getWidth(),bit1.img:getHeight(),bit2.x,bit2.y,bit2.img:getWidth(),bit2.img:getHeight()) then
            no_collision = false
            break;
          end
        end
      end

      return no_collision
end
function move_block(dt)

  if blocks[active_block] then

    if love.keyboard.isDown('left','a') then
        for i, bit in ipairs(blocks[active_block]) do
          if blocks[active_block][4].x > 0 then
            bit.x = bit.x - 32
          end
        end
    elseif love.keyboard.isDown('right','d') then
        for i, bit in ipairs(blocks[active_block]) do
          if blocks[active_block][4].x < 500 then
            bit.x = bit.x + 32
          end
        end
    end
  end

end
--main block game logic
function block_update(dt)

  block_timer = block_timer + dt*10

  if block_timer > 30 then
    create_block()
  end
  
  move_block(dt)

  -- loop through each block and check if it has collided, if not move it.
  for i, block1 in ipairs(blocks) do

    local no_collision = true

    for k, block2 in ipairs(inactive_blocks) do

      if block1 == block2 then
        break
      end

      no_collision = check_block_collision(block1,block2,no_collision)

      --no reason to keep checking for a collision if we already found one
      if not no_collision then
        break
      end
    end

    if no_bottom(block1) and no_collision then

      for k, bit in ipairs(block1) do
        bit.y = bit.y + (200*dt)
      end
    else
      table.insert(inactive_blocks, block1)
      table.remove(blocks, i)
    end
  
  

  end

end
function love.load(arg)
  bit1_img = love.graphics.newImage('assets/bit1.png')
  bit2_img = love.graphics.newImage('assets/bit2.png')
  bit3_img = love.graphics.newImage('assets/bit3.png')
  bit4_img = love.graphics.newImage('assets/bit4.png')
  bit5_img = love.graphics.newImage('assets/bit5.png')
  bit6_img = love.graphics.newImage('assets/bit6.png')
  bit7_img = love.graphics.newImage('assets/bit7.png')
end

function love.update(dt)

  block_update(dt)

end

function love.draw()

  for i, block in ipairs(blocks) do
    for k, bit in ipairs(block) do
      love.graphics.draw(bit.img, bit.x, bit.y)
    end
  end
  for i, block in ipairs(inactive_blocks) do
    for k, bit in ipairs(block) do
      love.graphics.draw(bit.img, bit.x, bit.y)
    end
  end

end

