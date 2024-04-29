CreateNetwork = require "createNetwork"
Persistence = require "deps.persistence"

---@param filename string
---@return Model
function LoadModel(filename)
    local model = persistence.load(filename)
    if model == nil then
        error("LoadModel failed (cause: model == nil), does the file \""..filename.."\" exist?")
    end
    if model.arch == nil then
        error("LoadModel failed (cause: arch == nil), try loading manually (see).")
    end
    if model.weights == nil then
        error("LoadModel failed (cause: weights == nil).")
    end

    return model
end

return LoadModel