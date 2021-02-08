input = [[
#.##....
.#.#.##.
###.....
....##.#
#....###
.#.#.#..
.##...##
#..#.###
]]
function parse_input(input)
    local arr = {}
    arr[0] = {}
    for line in string.gmatch(input, ".-\n") do
        arr[0][#arr[0] + 1] = {}
        for state in string.gmatch(line, "%p") do
            arr[0][#arr[0]][#arr[0][#arr[0]] + 1] = state
        end
    end
    return arr
end

function printArray(A)
	for i=1,#A do
		io.write(tostring(A[i]) .. ", ")
	end
	io.write("\n")
end

function part1()
    -- function to create arr of inactives for specific z value
    function createInactives(arr, row, col)
        for i = 1, row do
            arr[i] = {}
            for j = 1, col do
                arr[i][j] = "."
            end
        end
    end

    -- function to expand arr for one z value
    function expandInactives(arr, row, col)
        --insert top row
        table.insert(arr, 1, {})
        for i = 1, col + 2 do
            arr[1][i] = "."
        end
        --insert front and back inactives for rows in between
        for i = 2, row + 1 do
            table.insert(arr[i], 1, ".")
            table.insert(arr[i], ".")
        end
        --insert bottom row
        table.insert(arr, {})
        for i = 1, col + 2 do
            arr[#arr][i] = "."
        end
    end

    -- check if array plane is fully inactive
    function isInactive(arr, row, col)
        for i = 1, row do
            for j = 1, col do
                if arr[i][j] == "#" then
                    --print(false)
                    return false
                end
            end
        end
        --print(true)
        return true
    end

    -- check how many neighbors are active
    local function checkNeighbors(arr, x, y, z, width, height)
        local count = 0 -- number of neighbors active
        local minz = z-1 >= -height and z-1 or z
        local maxz = z+1 <= height and z+1 or z
        for j = minz, maxz do
            for k = y - 1, y + 1 do
                for l = x - 1, x + 1 do
                    if not (k < 1 or k > width or l < 1 or l > width) then
                        
                        if (j ~= z or k ~= y or l ~= x) and arr[j][k][l] == "#" then
                            count = count + 1
                        end
    
                    end
                end
            end
        end
        -- print(x.." "..y.." "..z..":"..count)
        return count
    end
    
    -- MAIN PROGRAM --

    local inputArr = parse_input(input)
    -- for i = 1, #inputArr[0] do
    --     printArray(inputArr[0][i])
    -- end

    local height = 0 -- number of z values above origin
    local width = #inputArr[0] -- width (length and breadth) of entire cube
    --print(width)
    -- complete 6 cycles
    for cycle = 1, 6 do
        -- increases height by 1
        height = height + 1
        --print("height:".. height)
        -- create z plane below
        inputArr[-height] = {}
        createInactives(inputArr[-height], width, width)
        -- create z plane above
        inputArr[height] = {}
        createInactives(inputArr[height], width, width)

        local newstate = {} -- create copy of old state
        width = width + 2 -- expand  width

        for zval = -height, height do
            expandInactives(inputArr[zval], width - 2, width - 2) -- expand width of array
            newstate[zval] = {}
            --print(zval)
            for y = 1, width do
                --printArray(inputArr[zval][y])
                newstate[zval][y] = {}
                for x = 1, width do
                    newstate[zval][y][x] = inputArr[zval][y][x]
                end
            end
        end

        -- manipulate each cube based on activity
        for zval = -height, height do
            for y = 1, width do
                for x = 1, width do
                    local check = checkNeighbors(inputArr, x, y, zval, width, height)
                    if inputArr[zval][y][x] == "#" then
                        if check ~= 2 and check ~= 3 then
                            newstate[zval][y][x] = "."
                        end
                    else
                        if check == 3 then
                            newstate[zval][y][x] = "#"
                        end
                    end
                end
            end
        end

        -- copy to input array
        inputArr = newstate

        -- check if bottom-most and top-most planes are completely inactive, remove if they are
        if isInactive(inputArr[-height], width, width) and isInactive(inputArr[height], width, width) then
            height = height - 1
        end
    end

    local countActives = 0 -- number of actives after 6 cycles

    -- count number of active
    for zval = -height, height do
        --print(zval)
        for i = 1, width do
            --printArray(inputArr[zval][i])
            for j = 1, width do
                if inputArr[zval][i][j] == "#" then
                    countActives = countActives + 1
                end
            end
        end
    end

    return countActives
end

function part2()
    -- check how many neighbors are active
    local function checkNeighbors(arr, x, y, z, w, width, height, hyper)
        local count = 0 -- number of neighbors active
        local minz = z-1 >= -height and z-1 or z
        local maxz = z+1 <= height and z+1 or z
        local minw = w-1 >= -hyper and w-1 or w
        local maxw = w+1 <= hyper and w+1 or w
        for i = minw, maxw do
            for j = minz, maxz do
                for k = y - 1, y + 1 do
                    for l = x - 1, x + 1 do
                        if not (k < 1 or k > width or l < 1 or l > width) then
                            
                            if (i ~= w or j ~= z or k ~= y or l ~= x) and arr[i][j][k][l] == "#" then
                                count = count + 1
                            end
        
                        end
                    end
                end
            end
        end        

        -- print(x.." "..y.." "..z..":"..count)
        return count
    end
    
    -- MAIN PROGRAM --

    local inputArr = {}
    inputArr[0] = parse_input(input)
    local height, hyper = 0, 0 -- number of z,w values above origin
    local width = #inputArr[0][0] -- width (length and breadth) of entire cube
    --print(width)
    -- complete 6 cycles
    for cycle = 1, 6 do
        -- increases height and hyper by 1
        height, hyper = height + 1, hyper + 1
        -- create additional hyper and height surrounding
        for w = -hyper, hyper do
            if inputArr[w] == nil then
                inputArr[w] = {}
            end
            for z = -height, height do
                if inputArr[w][z] == nil then
                    inputArr[w][z] = {}
                    createInactives(inputArr[w][z], width, width)
                end
            end
        end

        local newstate = {} -- create copy of old state
        width = width + 2 -- expand  width
        
        for w = -hyper, hyper do
            newstate[w] = {}
            for zval = -height, height do
                --print(w.." "..zval)
                expandInactives(inputArr[w][zval], width - 2, width - 2) -- expand width of array
                newstate[w][zval] = {}
                for y = 1, width do
                    --printArray(inputArr[w][zval][y])
                    newstate[w][zval][y] = {}
                    for x = 1, width do
                        newstate[w][zval][y][x] = inputArr[w][zval][y][x]
                    end
                end
            end
        end



        -- manipulate each cube based on activity
        for w = -hyper, hyper do
            for zval = -height, height do
                for y = 1, width do
                    for x = 1, width do
                        local check = checkNeighbors(inputArr, x, y, zval, w, width, height, hyper)
                        if inputArr[w][zval][y][x] == "#" then
                            if check ~= 2 and check ~= 3 then
                                newstate[w][zval][y][x] = "."
                            end
                        else
                            if check == 3 then
                                newstate[w][zval][y][x] = "#"
                            end
                        end
                    end
                end
            end
        end

        -- copy to input array
        inputArr = newstate

    end

    local countActives = 0 -- number of actives after 6 cycles

    -- count number of active
    for w = -hyper, hyper do
        for zval = -height, height do
            --print(w.." "..zval)
            for i = 1, width do
                --printArray(inputArr[w][zval][i])
                for j = 1, width do
                    if inputArr[w][zval][i][j] == "#" then
                        countActives = countActives + 1
                    end
                end
            end
        end
    end

    return countActives
end

print(part1())
print(part2())

