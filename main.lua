--block globals
blocks = {}
bit_img = nil
block_timer = 0

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

function create_block()

    local bits = {}
    local random_position = math.random(10, love.graphics.getWidth() - 100)
    local new_bit = { x = random_position, y = -100, img = bit_img}
    table.insert(bits,new_bit)
    new_bit = { x = random_position + 32, y = -100, img = bit_img}
    table.insert(bits,new_bit)
    new_bit = { x = random_position + 64, y = -100, img = bit_img}
    table.insert(bits,new_bit)
    new_bit = { x = random_position + 96, y = -100, img = bit_img}
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
--all block game logic
function block_update(dt)

  block_timer = block_timer + dt*10

  if block_timer > 10 then
    create_block()
  end
  
  -- loop through each block and check if it has collided, if not move it.
  for i, block1 in ipairs(blocks) do

    local no_collision = true

    for k, block2 in ipairs(blocks) do

      if block1 == block2 then
        break
      end

      no_collision = check_block_collision(block1,block2,no_collision)

      --no reason to keep checking for a collision if we already found one
      if not no_collision then
        break
      end
    end

    if (block1[1].y + block1[1].img:getHeight() < 750) and no_collision then

      for k, bit in ipairs(block1) do
        bit.y = bit.y + (200*dt)
      end

    end

  end

end
function love.load(arg)
  bit_img = love.graphics.newImage('assets/solo_block.png')
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

end

