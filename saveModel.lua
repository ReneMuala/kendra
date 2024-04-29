Persistence = require "deps.persistence"

---@param filename string
---@param model Model
function SaveModel(filename, model)
    if model.arch == nil then
        print("WARNING: (mode.arch == nil) you may need to load the network manually.")
    end
    Persistence.store(filename, model)
end

return SaveModel