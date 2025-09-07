--[[
    GD50
    Super Mario Bros. Remake

    -- LevelMaker Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

LevelMaker = Class{}

function LevelMaker.generate(width, height)
    -- Initialize tables to store tiles, entities, and objects
    local tiles = {}
    local entities = {}
    local objects = {}

    -- Set the initial tile ID to ground
    local tileID = TILE_ID_GROUND

    -- Determine whether to draw tiles with toppers
    local topper = true
    -- Randomly select tileset and topperset
    local tileset = math.random(20)
    local topperset = math.random(20)

    -- Initialize flags for key and key block spawning
    local is_key_spwaned = false
    local is_keyBlock_spawned = false
    -- Randomly select a lockset
    local lockset = math.random(4)

    -- Insert blank tables into tiles for later access
    for x = 1, height do
        table.insert(tiles, {})
    end

    -- Column by column generation instead of row; better for platformers
    for x = 1, width do
        -- Start with an empty tile
        local tileID = TILE_ID_EMPTY

        -- Lay out the empty space
        for y = 1, 6 do
            table.insert(tiles[y], Tile(x, y, tileID, nil, tileset, topperset))
        end

        -- Chance to just be emptiness
        if math.random(7) == 1 then
            -- Fill the rest with empty tiles
            for y = 7, height do
                table.insert(tiles[y], Tile(x, y, tileID, nil, tileset, topperset))
            end
        else
            -- Otherwise, fill with ground tiles
            tileID = TILE_ID_GROUND
            local blockHeight = 4

            for y = 7, height do
                table.insert(tiles[y], Tile(x, y, tileID, y == 7 and topper or nil, tileset, topperset))
            end

            -- Chance to generate a pillar
            if math.random(8) == 1 then
                blockHeight = 2

                -- Chance to generate a bush on the pillar
                if math.random(8) == 1 then
                    table.insert(objects, GameObject {
                        texture = 'bushes',
                        x = (x - 1) * TILE_SIZE,
                        y = (4 - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,
                        frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                        collidable = false
                    })
                end

                -- Pillar tiles
                tiles[5][x] = Tile(x, 5, tileID, topper, tileset, topperset)
                tiles[6][x] = Tile(x, 6, tileID, nil, tileset, topperset)
                tiles[7][x].topper = nil

            -- Chance to generate bushes
            elseif math.random(8) == 1 then
                table.insert(objects, GameObject {
                    texture = 'bushes',
                    x = (x - 1) * TILE_SIZE,
                    y = (6 - 1) * TILE_SIZE,
                    width = 16,
                    height = 16,
                    frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                    collidable = false
                })
            end

            -- Chance to spawn a locked block
            if math.random(width) <= x - 1 and not is_keyBlock_spawned then
                is_keyBlock_spawned = true

                lockedBlock = GameObject {
                    texture = 'keys-n-locks',
                    x = (x - 1) * TILE_SIZE,
                    y = (blockHeight - 1) * TILE_SIZE,
                    width = 16,
                    height = 16,
                    frame = lockset + 4,
                    collidable = true,
                    hit = false,
                    solid = true,
                    consumable = false,

                    onCollide = function(obj)
                        return
                    end,

                    onConsume = function(player, object)
                        lockedBlock = nil
                        gSounds['powerup-reveal']:play()

                        -- Create flag
                        local flagX = width
                        local is_colFree = false

                        while not is_colFree do
                            flagX = flagX - 1
                            is_colFree = not (tiles[7][flagX].id == tiles[6][flagX].id)

                            for k, object in pairs(objects) do
                                if (object.x - 1) == flagX then
                                    is_colFree = false
                                end
                            end
                        end

                        table.insert(objects, GameObject {
                            texture = 'flags',
                            frame = math.random(6),
                            x = ((flagX - 1) * TILE_SIZE),
                            y = 3 * TILE_SIZE,
                            width = 16,
                            height = 48,
                            collidable = false,
                            consumable = true,
                            solid = false,

                            onConsume = function()
                                gStateMachine:change('play', {
                                    ['score'] = player.score,
                                    ['width'] = width + 10
                                })
                            end
                        })

                        table.insert(objects, GameObject {
                            texture = 'flags',
                            frame = 7 + (3 * math.random(0, 3)),
                            x = (flagX) * TILE_SIZE - 8,
                            y = 3 * TILE_SIZE + 6,
                            width = 16,
                            height = 16,

                            animation = Animation {
                                frames = {0, 1},
                                interval = 0.25
                            },

                            collidable = false,
                            consumable = false,
                            solid = false
                        })
                    end
                }

                table.insert(objects, lockedBlock)

            -- Chance to spawn a key
            elseif math.random(width) <= x - 1 and not is_key_spwaned then
                is_key_spwaned = true

                table.insert(objects, GameObject {
                    texture = 'keys-n-locks',
                    x = (x - 1) * TILE_SIZE,
                    y = (blockHeight - 1) * TILE_SIZE,
                    width = 16,
                    height = 16,
                    frame = lockset,
                    collidable = true,
                    consumable = true,
                    solid = false,

                    onConsume = function(player, object)
                        gSounds['pickup']:play()
                        lockedBlock['consumable'] = true
                        lockedBlock['solid'] = false
                    end
                })

            -- Chance to spawn a block
            elseif math.random(10) == 1 then
                table.insert(objects, GameObject {
                    texture = 'jump-blocks',
                    x = (x - 1) * TILE_SIZE,
                    y = (blockHeight - 1) * TILE_SIZE,
                    width = 16,
                    height = 16,
                    frame = math.random(#JUMP_BLOCKS),
                    collidable = true,
                    hit = false,
                    solid = true,

                    onCollide = function(obj)
                        -- Spawn a gem if the block hasn't been hit yet
                        if not obj.hit then
                            if math.random(5) == 1 then
                                local gem = GameObject {
                                    texture = 'gems',
                                    x = (x - 1) * TILE_SIZE,
                                    y = (blockHeight - 1) * TILE_SIZE - 4,
                                    width = 16,
                                    height = 16,
                                    frame = math.random(#GEMS),
                                    collidable = true,
                                    consumable = true,
                                    solid = false,

                                    onConsume = function(player, object)
                                        gSounds['pickup']:play()
                                        player.score = player.score + 100
                                    end
                                }

                                -- Make the gem move up from the block and play a sound
                                Timer.tween(0.1, {
                                    [gem] = {y = (blockHeight - 2) * TILE_SIZE}
                                })
                                gSounds['powerup-reveal']:play()

                                table.insert(objects, gem)
                            end

                            obj.hit = true
                        end

                        gSounds['empty-block']:play()
                    end
                })
            end
        end
    end

    -- Create a tile map with the generated tiles
    local map = TileMap(width, height)
    map.tiles = tiles

    -- Return a game level with the entities, objects, and tile map
    return GameLevel(entities, objects, map)
end
