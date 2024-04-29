---@param orign Neuron
---@param dest Neuron
---@return Axon
function Axon(orign, dest)
    ---@class AxonNeurons
    ---@field public orign Neuron
    ---@field public dest Neuron
    
    ---@class Axon
    ---@field public weight number
    ---@field public neurons AxonNeurons
    ---@field public forwardPropagate fun(x:number)
    ---@field public trainingBuffer table | nil

    ---@type Axon
    local ax = {
        weight = math.random(),
        neurons = {
            orign = orign,
            dest = dest
        }
    }

    ---@param x number
    function ax.forwardPropagate(x)
        ax.neurons.dest.addInput(x * ax.weight)
    end

    return ax
end

return Axon
