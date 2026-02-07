BoardScore = {}
function BoardScore:new(o)
  printh("called boardscore:new")
  local base = {}
  for n in all(_level_names) do 
    add(base, {
      name = n,
      nomiss = false,
      boosttime = false,
      juicebox = false,
    })
  end
  o = o or base
  setmetatable(o, self)
  self.__index = self
  return o
end

function BoardScore:load()
 -- load from local
end

function BoardScore:save()
  --save to local
  for i, level in ipairs(self) do -- foreach level...
    printh("saving level index: "..i)
    local score = 0     
    for k, val in pairs(level) do
      if k == "nomiss" and val then
        score |= 1 << 0
      end
      if k == "boosttime" and val then
        score |= 1 << 1
      end
      if k == "juicebox" and val then
        score |= 1 << 2
      end
    end
    printh("level has score: "..score)
    dset(i, score)
    printh("saved level score")
  end
end

function BoardScore:lookup(level_name)
  for i=1,#self do
    if self[i].name == level_name then
      return self[i]
    end
  end
end

function BoardScore:update(level_name, key, value)
  for i=1,#self do
    if self[i].name == level_name then
      self[i][key] = value
    end
  end
end

function BoardScore:getLevelTotal()

end

function BoardScore:getAllTotal()

end

-- for adding current run to previous runs
function BoardScore:merge(run)
  for level_name, scores in pairs(run) do
    for score_name, v in pairs(scores) do
      self[level_name][score_name] = v or self[score_name][v]
    end
  end
end

--[[
  "levelname": {
    "whatever": true,
    "another": false,
  }
  nomisses - don't biff any jumps
  juicebox - the thing you have to get on each level)
  boosttime - boosting for N% of total level time
]]--
