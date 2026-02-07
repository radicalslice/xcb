BoardScore = {}
function BoardScore:new(o)
  printh("called boardscore:new")
  local base = {}
  for n in all(_level_names) do 
    base[n] = {
      nomiss = false,
      juicebox = false,
      boosttime = false,
    }
  end
  for k, v in pairs(base) do
    printh("loop Entry in base: "..k)
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
end

function BoardScore:update(level_name, key, value)
  _boardscore[level_name][key] = value
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
