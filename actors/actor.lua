Actor = class("Actor", Entity)

function Actor:move(direction)
  self.direction = direction
end

function Actor:keydown(dt)
  if self.dt_since_input > 0.1 then
    local movement = {x = 0, y = 0}
    local moved = false
    for key, m in pairs(self.inputs) do
      if love.keyboard.isDown(key) then
        self.dt_since_input = 0
        moved = true
        movement.x = movement.x + m.x
        movement.y = movement.y + m.y
      end
    end
    if moved then
      self:move(movement)
    end
  end
  self.dt_since_input = self.dt_since_input + dt
  return moved
end

function Actor:update(dt)
  if self.inputs then
    if not self:keydown(dt) then
    end
  end
  return self:updatePosition(dt)
end

function Actor:updatePosition(dt)
  if not self.direction then
    return false
  end

  local old_position = {x = self.position.x, y = self.position.y}

  self.position.x = self.position.x + self.direction.x
  self.position.y = self.position.y + self.direction.y
  local tile = self.level.map:getTile(self.position)
  if not tile or not tile.passable then
    self.position = old_position
    return false
  end
  self.level.map:fitIntoMap(self.position)

  self.level.map:moveEntity(self, old_position, self.position)

  if tile.exit then
    self.level.exit_reached = tile.exit
  end

  if self.inputs then
    --self.level.views.map:centerAt(self.position)
  end

  self.direction = nil
  self:positionUpdated()
  return true
end

function Actor:positionUpdated()

end
function Actor:finishReached()
  self.level.paused = true
  self.level.ended = true
  love.draw = finishScreen
end

