local function intersection(a, b)
  local res = {}
  for k in pairs(a) do
    res[k] = b[k]
  end
  return res
end

local lines = {}
local allergens = {}
local words = {}

for line in io.lines("input.txt") do
  for ingredientList, allergenList in string.gmatch(line, "(.+) %(contains (.+)%)") do
    local ingredients = {}
    for t in ingredientList:gmatch("%w+") do
      ingredients[t] = true
      words[t] = true
    end
    lines[#lines + 1] = ingredients
    for a in allergenList:gmatch("%w+") do
      if allergens[a] == nil then
        allergens[a] = ingredients
      else
        allergens[a] = intersection(allergens[a], ingredients)
      end
    end
  end
end

for _, a in pairs(allergens) do
  for w, _ in pairs(a) do
    words[w] = nil
  end
end

local counter = 0
for _, v in pairs(lines) do
  for ingredient, _ in pairs(v) do
    if words[ingredient] then
      counter = counter + 1
    end
  end
end

print(counter)
