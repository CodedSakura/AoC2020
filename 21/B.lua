local function intersection(a, b)
  local res = {}
  for k in pairs(a) do
    res[k] = b[k]
  end
  return res
end

local function difference(a, b)
  local res = {}
  for k in pairs(a) do
    if not b[k] then res[k] = true end
  end
  return res
end

local function tableLength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
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

while true do
  local allDone = true
  for c, a in pairs(allergens) do
    if tableLength(a) == 1 then
      for v, b in pairs(allergens) do
        if v ~= c then
          allergens[v] = difference(b, a)
        end
      end
    else
      allDone = false
    end
  end
  if allDone then
    break
  end
end

local allergenList = {}
for k, _ in pairs(allergens) do table.insert(allergenList, k) end
table.sort(allergenList)

local res = ""
for _, v in pairs(allergenList) do
  for k, _ in pairs(allergens[v]) do
    res = res .. k .. ","
  end
end

print(res:sub(1, #res-1))
