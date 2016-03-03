blocks = {}
block_l_img = nil

function love.load(arg)
  block_l_img = love.graphics.newImage('assets/block_l.png')
end

function love.update(dt)

  random_number = math.random(10, love.graphics.getWidth() - 100)
  local new_block = { x = random_number, y = -100, img = block_l_img}
  table.insert(blocks,new_block)

end

function love.draw()

  for i, block in ipairs(blocks) do
    love.graphics.draw(block.img, block.x, block.y)
  end

end

