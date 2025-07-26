-- modules/net/crypto.lua
-- Hashing and XOR-based encryption utilities

local crypto = {}
local bxor = bit and bit.bxor or bit32.bxor

function crypto.enhancedHash(message)
    local hash = 0
    for i = 1, #message do
        local c = string.byte(message, i)
        hash = (hash + c * 31) % 0x10000
    end
    return string.format("%04x", hash)
end

function crypto.encrypt(message, key)
    local numericKey = tonumber(key, 16) or 0
    local out = {}
    for i = 1, #message do
        local b = string.byte(message, i)
        table.insert(out, string.char(bxor(b, numericKey % 256)))
    end
    return table.concat(out)
end

function crypto.decrypt(message, key)
    return crypto.encrypt(message, key)
end

return crypto
