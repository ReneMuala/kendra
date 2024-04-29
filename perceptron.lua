Neuron = require "neuron"
---@param size number
---@param actFunc ActivationFunction
---@return Perceptron
function Perceptron(size, actFunc)
    ---@class Perceptron
    ---@field public bias Neuron
    ---@field public neus Neuron[]
    ---@field public addInput fun(input:number[])
    ---@field public getOutput fun():number[]
    ---@field public print fun()
    ---@field public attach fun(other:Perceptron)
    ---@field public getRelatedAxons fun(other:Perceptron):Axon[]
    ---@field public getWeights fun():number[][]
    ---@field public setWeights fun(weights:number[])
    ---@field public getAxons fun():Axon[]
    ---@field public cleanup fun()
    ---@field public forwardPropagate fun()

    ---@type Perceptron
    local perc = {
        bias = Neuron(actFunc),
        neus = {}
    }

    perc.bias.addInput(1)
    for _ = 1, size do
        perc.neus[#perc.neus + 1] = Neuron(actFunc)
    end

    function perc.addInput(input)
        if not (#input == #perc.neus) then
            error("input size doesnt mach perceptron neurons size "..#input.." vs "..#perc.neus)
        end
        for i, neu in ipairs(perc.neus) do
            neu.addInput(input[i])
        end
    end

    function perc.getOutput()
        ---@type number[]
        local output = {}
        for _, neu in ipairs(perc.neus) do
            output[#output+1] = neu.getOutput()
        end
        return output
    end

    function perc.getWeights()
        ---@type number[][]
        local weights = {}
        for _, neuron in ipairs(perc.neus) do
            weights[#weights+1] = neuron.getWeights()
        end
        weights[#weights+1] = perc.bias.getWeights()
        return weights
    end

    ---@param weights number[][]
    function perc.setWeights(weights)
        if not(#weights - 1 == #perc.neus) then
            error("number of weights[] doesnt match perceptron's neurons count (" ..#weights.." vs "..(#perc.neus+1)..")" )
        end

        for index, neuron in ipairs(perc.neus) do
            neuron.setWeights(weights[index])
        end
        perc.bias.setWeights(weights[#weights])
    end

    function perc.cleanup()
        for _, neu in ipairs(perc.neus) do
            neu.cleanup()
        end
    end

    function perc.print()
        for _, neu in ipairs(perc.neus) do
            neu.print()
        end
    end

    function perc.attach(other)
        for _, thisNeu in ipairs(perc.neus) do
            for _, otherNeu in ipairs(other.neus) do
                thisNeu.attach(otherNeu)
                perc.bias.attach(otherNeu)
            end
        end
    end

    --- returns axons attaching to other percetron's neuron
    ---@param otherNeuron Neuron
    ---@return Axon[]
    function perc.getRelatedAxons(otherNeuron)
        local axons = {}
        for _, neuron in ipairs(perc.neus) do
            for _, axon in ipairs(neuron.axons) do
                if axon.neurons.dest == otherNeuron then
                    axons[#axons + 1] = axon
                end
            end
        end
        return axons
    end
    
    ---@return Axon[]
    function perc.getAxons()
        local axons = {}
        for _, neuron in ipairs(perc.neus) do
            for _, axon in ipairs(neuron.axons) do
                axons[#axons + 1] = axon
            end
        end
        for _, axon in ipairs(perc.bias.axons) do
            axons[#axons + 1] = axon
        end
        return axons
    end

    function perc.forwardPropagate()
        perc.bias.forwardPropagate()
        for _, thisNeu in ipairs(perc.neus) do
            thisNeu.forwardPropagate()
        end
    end

    return perc
end

return Perceptron
