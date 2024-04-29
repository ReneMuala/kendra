local inspect = require 'deps.inspect'

---@class Error
---@field public value number
---@field public output number | nil
---@field public expected number | nil

---@alias StochasticGradientDescentVerbosity integer @ 2 - Full, 1 - TotalOnly, 0 -> None 

---@class TrainData
---@field public input number[]
---@field public output number[]

---@param network NeuralNetwork
---@param learningRate number
---@param momentum number
---@param errorFunc ErrorFunction
---@return StochasticGradientDescent
function StochasticGradientDescent(network, learningRate, momentum, errorFunc)

    ---@class StochasticGradientDescent 
    ---@field public net NeuralNetwork
    ---@field public learningRate number
    ---@field public momentum number
    ---@field public verbosity StochasticGradientDescentVerbosity
    ---@field public errorFunc ErrorFunction
    
    grad = {
        net             = network,
        learningRate    = learningRate,
        momentum        = momentum,
        errorFunc       = errorFunc,
        verbosity       = 0,
    }

    function grad._describeStage(netError)
        if not(grad.verbosity == 0) then 
            local netErrorSum = 0
            for _, error in ipairs(netError) do
                netErrorSum = netErrorSum + error.value
            end
            if grad.verbosity == 2 then 
                print("Network Error = ", inspect(netError))
            end
            if grad.verbosity == 1 or grad.verbosity == 2 then 
                print("Total Network Error = ", netErrorSum)
            end
        end
    end

    function grad.forwardPropagate(input)
        grad.net.addInput(input)
        grad.net.forwardPropagate()
    end
 
    ---@param expected number[]
    ---@return Error
    function grad.computeNetworkError(expected)
        if not (#expected == #grad.net.outputLayer.neus) then
            error "Expected output size doesn't match output's layers size, check the network architecture."
        end
        local error = {}
        for index, neuron in ipairs(grad.net.outputLayer.neus) do
            error[#error + 1] = {
                value = grad.errorFunc.fx(expected[index], neuron.output),
                output = neuron.output,
                expected = expected[index],
            }
        end
        return error
    end

    --- func desc
    ---@param netError Error[]
    function grad.placeNetErrorOnOutputLayer(netError)
        grad._describeStage(netError)
        for index, neuron in ipairs(grad.net.outputLayer.neus) do
            if neuron.trainingBuffer == nil then neuron.trainingBuffer = {} end
            neuron.trainingBuffer.error = netError[index]
        end
    end

    ---@param layer Perceptron
    function grad.computeLastLayerDelta(layer)
        for _, neuron in ipairs(layer.neus) do
            neuron.trainingBuffer.delta = - neuron.trainingBuffer.error.value * neuron.actFunc.dfx(neuron.input)
        end
    end

    ---@param layer Perceptron
    function grad.computeLayerDelta(layer)
        for _, neuron in ipairs(layer.neus) do
            if neuron.trainingBuffer == nil then neuron.trainingBuffer = {} end
            neuron.trainingBuffer.delta = 0
            local delta = neuron.trainingBuffer.delta
            for _, axon in ipairs(layer.getAxons()) do
                delta = delta + neuron.actFunc.dfx(neuron.input) * axon.weight * axon.neurons.dest.trainingBuffer.delta
            end
        end
    end
    

    ---@param neuron Neuron
    ---@param axon Axon
    ---@return number 
    function grad.computeWeightVariation(neuron, axon)
        local LWV = 0
        if axon.trainingBuffer == nil then axon.trainingBuffer = {} end
        if not (axon.trainingBuffer.lastWeightVariation == nil) then
            LWV = axon.trainingBuffer.lastWeightVariation
        end
        return 
            --[[ lambda ]] grad.learningRate *
            --[[ dE/dw ]] neuron.output * axon.neurons.dest.trainingBuffer.delta +
            --[[ momentum * DeltaW ]] grad.momentum * LWV
    end

    ---@param layer Perceptron
    function grad.updateWeights(layer)
        for _, neuron in ipairs(layer.neus) do
            for _, axon in ipairs(neuron.axons) do 
                local weightVariation = grad.computeWeightVariation(neuron, axon)
                axon.weight = axon.weight + weightVariation
                axon.trainingBuffer.lastWeightVariation = weightVariation
            end
        end
    end

    function grad.backwardPropagate()
        local layerCount = #grad.net.layers
        local layers = grad.net.layers
        for i = layerCount, 1, -1 do
            if i == layerCount then
                grad.computeLastLayerDelta(layers[i])
            else
                grad.computeLayerDelta(layers[i])
            end
            grad.updateWeights(layers[i])
        end
    end

    ---@param trainData TrainData
    function grad.train(trainData)
        for _, data in ipairs(trainData) do
            grad.net.cleanup()
            grad.forwardPropagate(data.input)
            grad.placeNetErrorOnOutputLayer(grad.computeNetworkError(data.expect))
            -- print(inspect(data.input), inspect(grad.net.getOutput()))
            grad.backwardPropagate()
        end
    end
    return grad
end

return StochasticGradientDescent