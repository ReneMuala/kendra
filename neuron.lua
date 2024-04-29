Axon = require "axon"

---@param actFunc ActivationFunction
---@return Neuron
function Neuron(actFunc)

    ---@class Neuron
    ---@field public actFunc ActivationFunction
    ---@field public input number
    ---@field public output number
    ---@field public axons Axon[]
    ---@field public addInput fun(input:number)
    ---@field public getOutput fun():number
    ---@field public getWeights fun():number[]
    ---@field public setWeights fun(weights:number[])
    ---@field public cleanup fun()
    ---@field public activate fun()
    ---@field public print fun()
    ---@field public trainingBuffer table | nil
    ---@field public attach fun(other:Neuron)
    ---@field public forwardPropagate fun()
    
    local neu = {
        actFunc = actFunc,
        input   = 0,
        output  = 0,
        axons = {}
    }

    function neu.addInput(value)
        neu.input = neu.input + value
    end

    -- getters are not necessary, this one exists to improve the developer experience
    function neu.getOutput()
        return neu.output
    end

    function neu.getWeights()
        ---@type number[]
        local weights = {}
        for _, axon in ipairs(neu.axons) do
            weights[#weights+1] = axon.weight
        end
        return weights
    end

    ---@param weights number[]
    function neu.setWeights(weights)
        if not(#weights == #neu.axons) then
            error("number of weights doesnt match neuron's axon count (" ..#weights.." vs "..#neu.axons..")" )
        end
        for index, axon in ipairs(neu.axons) do
            axon.weight = weights[index]
        end
        return weights
    end

    function neu.cleanup()
        neu.input = 0;
    end

    function neu.activate()
        neu.output = neu.actFunc.fx(neu.input)
    end

    function neu.print()
        print(neu, "i:", neu.input, "o:", neu.output, " #axons: ", #neu.axons)
    end

    function neu.attach(other)
        neu.axons[#neu.axons + 1] = Axon(neu, other)
    end

    function neu._forwardPropagateAxons()
        for i, axon in ipairs(neu.axons) do
            axon.forwardPropagate(neu.output)
        end
    end

    function neu.forwardPropagate()
        neu.activate()
        neu._forwardPropagateAxons()
    end

    return neu
end

return Neuron
