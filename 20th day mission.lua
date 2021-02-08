input = [[
Tile 2311:
..##.#..#.
##..#.....
#...##..#.
####.#...#
##.##.###.
##...#.###
.#.#.#..##
..#....#..
###...#.#.
..###..###

Tile 1951:
#.##...##.
#.####...#
.....#..##
#...######
.##.#....#
.###.#####
###.##.##.
.###....#.
..#.#..#.#
#...##.#..

Tile 1171:
####...##.
#..##.#..#
##.#..#.#.
.###.####.
..###.####
.##....##.
.#...####.
#.##.####.
####..#...
.....##...

Tile 1427:
###.##.#..
.#..#.##..
.#.##.#..#
#.#.#.##.#
....#...##
...##..##.
...#.#####
.#.####.#.
..#..###.#
..##.#..#.

Tile 1489:
##.#.#....
..##...#..
.##..##...
..#...#...
#####...#.
#..#.#.#.#
...#.#.#..
##.#...##.
..##.##.##
###.##.#..

Tile 2473:
#....####.
#..#.##...
#.##..#...
######.#.#
.#...#.#.#
.#########
.###.#..#.
########.#
##...##.#.
..###.#.#.

Tile 2971:
..#.#....#
#...###...
#.#.###...
##.##..#..
.#####..##
.#..####.#
#..#.#..#.
..####.###
..#.#.###.
...#.#.#.#

Tile 2729:
...#.#.#.#
####.#....
..#.#.....
....#..#.#
.##..##.#.
.#.####...
####.#.#..
##.####...
##..#.##..
#.##...##.

Tile 3079:
#.#.#####.
.#..######
..#.......
######....
####.#..#.
.#...#.##.
#.#####.##
..#.###...
..#.......
..#.###...
]]

function parse_input(input)
    local arr = {}
    local index = 0
    for line in string.gmatch(input, ".-\n") do
        line = string.gsub(line, "\n", "")
        if line ~= "" then -- not empty
            if string.find(line, "Tile") then
                index = tonumber(string.match(line, "%d+"))
                arr[index] = {}
            else
                table.insert(arr[index], line)
            end
        end
    end
    return arr
end

function printArray(A)
    local cnt = 0
	for k, v in pairs(A) do
		print("['"..tostring(k).."'] = " .. tostring(v)..",")
		cnt = cnt + 1
	end
end

function removeDuplicates(A)
    local hash = {}
    local res = {}

    for _,v in ipairs(A) do
        if (not hash[v]) then
            res[#res+1] = v 
            hash[v] = true
        end
    end
    return res
end

function getTableSize(t)
    local count = 0
    for _, __ in pairs(t) do
        count = count + 1
    end
    return count
end

-- removes borders of a tile
function removeBorders(arr)
    table.remove(arr, 1) -- removes first row
    table.remove(arr) -- removes last row
    for i = 1, #arr do
        arr[i] = string.sub(arr[i], 2, -2) -- removes left and right columns
    end
end

-- rotates tile counter-clockwise
function rotateLeft(arr)
    local newArr = {}
    for i = 1, #arr do
        newArr[i] = ""
        for j = 1, #arr[i] do
            newArr[i] = newArr[i]..string.sub(arr[j], -i, -i)
        end
    end
    return newArr
end

-- rotates tile clockwise
function rotateRight(arr)
    local newArr = {}
    for i = 1, #arr do
        newArr[i] = ""
        for j = 1, #arr[i] do
            newArr[i] = string.sub(arr[j], i, i)..newArr[i]
        end
    end
    return newArr
end

-- destructively flips array vertically
function dflipVert(arr)
    for i = 1, #arr do
        arr[i] = string.reverse(arr[i])
    end
    return arr
end

-- destructively flips array horizontally
function dflipHor(arr)
    local len = #arr
    local mid = math.floor(len/2)
    for i = 1, mid do
        local temp = arr[i]
        arr[i] = arr[len - i + 1]
        arr[len - i + 1] = temp
    end
    return arr
end

function part1()
    local inputArr = parse_input(input) -- table of tiles containing array of rows 1-10
    local bordersArr = {} -- table of tiles containing table of borders (with string l, r, t, b)
    local tilesArr = {} -- array of tiles
    for k, v in pairs(inputArr) do
        local top = v[1]
        local bottom = v[#v]
        local left, right = "", ""
        for i = 1, #v do
            left = left .. string.sub(v[i], 1, 1)
            right = right .. string.sub(v[i], #v[i], #v[i])
        end
        bordersArr[k] = {}
        bordersArr[k][left], bordersArr[k][right], bordersArr[k][top], bordersArr[k][bottom]
            = "l", "r", "t", "b"
        table.insert(tilesArr, k)
    end
    local answer = 1
    for i = 1, #tilesArr do -- for every tile
        local tile = tilesArr[i]
        -- io.write(tile..": ")
        local bordersWithLink = {}
        for j = 1, #tilesArr do
            if i ~= j then -- for every other tile
                local targetTile = tilesArr[j]
                for k, v in pairs(bordersArr[tile]) do
                    -- for every border in the tile, where k is the border of the tile
                    -- find borders of other (target) tiles that are the same
                    local borderDirTile = v
                    local borderDirTargetTile = bordersArr[targetTile][k] or bordersArr[targetTile][string.reverse(k)]
                    if borderDirTargetTile then
                        -- io.write(targetTile.." "..borderDirTargetTile..", "..borderDirTile.." | ")
                        table.insert(bordersWithLink, borderDirTile)
                    end
                end
            end
        end
        bordersWithLink = removeDuplicates(bordersWithLink) -- remove any duplicated border counts
        -- print("count: "..#bordersWithLink)
        if #bordersWithLink == 2 then -- only 2 borders are linked with other borders, i.e. corner tiles
            answer = answer * tile
        end
    end
    return answer
end

function part2()
    local inputArr = parse_input(input) -- table of tiles containing array of rows 1-10
    local bordersArr = {} -- table of tiles containing table of [borders] (with valuse: string l, r, t, b)
    local tilesArr = {} -- array of tiles
    local borderLinkArr = {} -- table of tiles containing border direction as keys [l/r/t/b] 
        -- and {connectedTile, borderDirection, bool reverse} as values. 
        -- e.g. borderLinkArr[tileNum][l] = {tileNum2, r, false}
        -- borderLinkArr[tile].borders = number of linked borders of the tile
    for k, v in pairs(inputArr) do
        local top = v[1]
        local bottom = v[#v]
        local left, right = "", ""
        for i = 1, #v do
            left = left .. string.sub(v[i], 1, 1)
            right = right .. string.sub(v[i], #v[i], #v[i])
        end
        bordersArr[k] = {}
        bordersArr[k][left], bordersArr[k][right], bordersArr[k][top], bordersArr[k][bottom]
            = "l", "r", "t", "b"
        table.insert(tilesArr, k)
    end
    local answer = 1
    for i = 1, #tilesArr do -- for every tile
        local tile = tilesArr[i]
        -- io.write(tile..": ")
        borderLinkArr[tile] = {}
        for j = 1, #tilesArr do
            if i ~= j then -- for every other tile
                local targetTile = tilesArr[j]
                for k, v in pairs(bordersArr[tile]) do
                    -- for every border in the tile, where k is the border of the tile
                    -- find borders of other (target) tiles that are the same
                    local borderDirTile = v
                    local borderDirTargetTile = bordersArr[targetTile][k]
                    
                    if bordersArr[targetTile][k] then
                        borderLinkArr[tile][borderDirTile] = {targetTile, borderDirTargetTile, false}
                        -- io.write(targetTile.." "..borderDirTargetTile..", "..borderDirTile.." | ")
                    elseif bordersArr[targetTile][string.reverse(k)] then
                        borderLinkArr[tile][borderDirTile] = {targetTile, borderDirTargetTile, true}
                        -- io.write(targetTile.." "..borderDirTargetTile..", "..borderDirTile.." | ")
                    else
                        -- IGNORE: not a border
                    end
                end
            end
        end
        borderLinkArr[tile]["borders"] = getTableSize(borderLinkArr[tile])
        if borderLinkArr[tile].borders == 2 then -- only 2 borders are linked with other borders, i.e. corner tiles
            answer = answer * tile
        end
    end
    return answer
end
print(part1())
print(part2())