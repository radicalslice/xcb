BoardScore = {}
function BoardScore:new(o)
  local base = {}
  for n in all(_level_names) do 
    add(base, {
      name = n,
      nomiss = {label="no biffs", val=false },
      boosttime = {label="boostlord", val=false },
      juicebox = {label="juicebox", val=false },
    })
  end
  o = o or base
  setmetatable(o, self)
  self.__index = self
  return o
end

function BoardScore:load()
  -- load from local
  for i, level_name in ipairs(_level_names) do
    local score = dget(i) 
    local level = self:lookup(level_name)
    if score & 1 > 0 then
      level["nomiss"].val = true 
    end
    if score & 1 << 1 > 0 then
      level["boosttime"].val = true 
    end
    if score & 1 << 2 > 0 then
      level["juicebox"].val = true 
    end
  end
end

function BoardScore:save()
  --save to local
  for i, level in ipairs(self) do -- foreach level...
    local score = 0     
    for k, val in pairs(level) do
      if k == "nomiss" and val.val then
        score |= 1 << 0
      end
      if k == "boosttime" and val.val then
        score |= 1 << 1
      end
      if k == "juicebox" and val.val then
        score |= 1 << 2
      end
    end
    dset(i, score)
  end
end

function BoardScore:lookup(level_name)
  for i=1,#self do
    if self[i].name == level_name then
      return self[i]
    end
  end
end

function BoardScore:update(level_name, key, newvalue)
  for i=1,#self do
    if self[i].name == level_name then
      self[i][key].val = newvalue
    end
  end
end

-- for adding current run to previous runs
function BoardScore:merge(run)
  for i=1,#run do
    -- printh("Got run level: "..run[i].name)
    local self_level = self:lookup(run[i].name)
    for score_name, val in pairs(run[i]) do
      if score_name != "name" then
        self_level[score_name].val = val.val or self_level[score_name].val
      end
    end
  end
end
