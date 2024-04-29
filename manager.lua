SaveModel = require "saveModel"
LoadModel = require "loadModel"
CreateNetwork = require "createNetwork"

---@param network NeuralNetwork
---@param filename string
---@return Manager
function Manager(network, filename)
    ---@class Manager
    ---@field public network NeuralNetwork
    ---@field public filename string
    ---@field public load fun()
    ---@field public tryLoad fun():boolean
    ---@field public save fun()

    ---@type Manager
    mng = {
        network = network,
        filename = filename
    }

    function mng.load()
        mng.network.set(LoadModel(mng.filename))
    end

    function mng.tryLoad()
        return pcall(mng.load)
    end

    function mng.save()
        SaveModel(mng.filename, mng.network.get())
    end
    return mng
end

return Manager