input = [[
mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
trh fvjkl sbzzf mxmxvkd (contains dairy)
sqjhc fvjkl (contains soy)
sqjhc mxmxvkd sbzzf (contains fish)
]]

function parseInput(input)
    local arr = {}
    for line in string.gmatch(input, ".-\n") do
        line = string.gsub(line, "\n", "")
        
    end
    return arr
end