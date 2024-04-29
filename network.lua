---@class NeuralNetworkArch
---@field public input number
---@field public output number
---@field public hidden number
---@field public hiddenCount number
---@field public inputActivationFunction ActivationFunction | nil
---@field public outputActivationFunction ActivationFunction | nil
---@field public hiddenActivationFunction ActivationFunction | nil

---@class Model
---@field public arch NeuralNetworkArch | nil
---@field public weights [][][]

---@param percepts Perceptron[]
---@return NeuralNetwork
function Network(percepts)
    if #percepts < 3 then
        error "Kendra networks must to have at least 3 Layers"
    end

    ---@class NeuralNetwork
    ---@field public layers Perceptron[]
    ---@field public outputLayer Perceptron
    ---@field public print fun()
    ---@field public get fun():Model
    ---@field public set fun(model:Model)
    ---@field public addInput fun(input:number[])
    ---@field public compute fun(input:number[]):number[]
    ---@field public trainingBuffer table | nil
    ---@field public arch NeuralNetworkArch | nil
    ---@field public getWeights fun():number[][][]
    ---@field public setWeights fun(weights:number[][][])
    ---@field public cleanup fun()
    ---@field public getOutput fun()
    ---@field public forwardPropagate fun()

    ---@type NeuralNetwork
    local net = {
        layers = percepts,
        outputLayer = percepts[#percepts]
    }

    math.randomseed(os.time())
    
    for i = 1, (#net.layers) - 1 do
        net.layers[i].attach(net.layers[i + 1])
    end

    function net.getOutput()
        return net.outputLayer.getOutput()
    end

    function net.getWeights()
        ---@type number[][][]
        local weights = {}
        for index, perceptron in ipairs(net.layers) do
            if not(#net.layers == index) then
                weights[#weights+1] = perceptron.getWeights()
            end
        end
        return weights
    end

    ---@param weights number[][][]
    function net.setWeights(weights)
        if not(#weights + 1 == #net.layers) then
            error("number of weights[][] + 1 doesnt match networks's layers count (" ..#weights.." + 1 vs "..#net.layers..")" )
        end
        for index, perceptron in ipairs(net.layers) do
            if index <= #weights then
                perceptron.setWeights(weights[index])
            end
        end
    end

    function net.compute(input)
        net.cleanup()
        net.addInput(input)
        net.forwardPropagate()
        return net.getOutput()
    end

    function net.get()
        return {
            arch = net.arch,
            weights = net.getWeights()
        }
    end

    ---@param model Model
    function net.set(model)
        net.setWeights(model.weights)
        net.arch = model.arch
    end

    function net.print()
        for _, perc in ipairs(net.layers) do
            print(perc)
            perc.print()
        end
    end

    function net.addInput(input)
        net.layers[1].addInput(input)
    end

    function net.cleanup()
        for _, perc in ipairs(net.layers) do
            perc.cleanup()
        end
    end

    function net.forwardPropagate()
        for _, perc in ipairs(net.layers) do
            perc.forwardPropagate()
        end
    end

    return net
end

return Network
