-- net_module.lua
-- Provides hashing and encryption/decryption utilities.

local Net = {}

----------------------------------------
-- Simple "enhanced" hash function
----------------------------------------
function Net.enhancedHash(message)
    local hash = 0
    for i = 1, #message do
        local c = string.byte(message, i)
        hash = (hash + c * 31) % 0x10000
    end
    -- Convert hash to a 4-character string in hex
    return string.format("%04x", hash)
end

----------------------------------------
-- Encryption: XOR each character with 
-- the hash's numeric value.
----------------------------------------
function Net.encryptMessage(message, key)
    local numericKey = tonumber(key, 16) or 0
    local output = {}
    for i = 1, #message do
        local m = string.byte(message, i)
        local e = bit.bxor(m, numericKey % 256)
        table.insert(output, string.char(e))
    end
    return table.concat(output)
end

----------------------------------------
-- Decryption: same as encryption (XOR).
----------------------------------------
function Net.decryptMessage(encrypted, key)
    return Net.encryptMessage(encrypted, key)
end

return Net
