-- modules/system/permissions.lua
-- Stub for future permission management

local permissions = {}

-- In this stub all actions are allowed
function permissions.check(user, action)
    return true
end

return permissions
