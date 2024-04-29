Functions = require "functions"
Network = require "network"
Perceptron = require "perceptron"

---@param arch NeuralNetworkArch
---@return NeuralNetwork
function CreateNetwork(arch)
    ---@type Perceptron[]
    local perceptrons = {
        Perceptron(arch.input, arch.inputActivationFunction or Functions.Sigmoid),
    }

    local hiddenActFunc = arch.hiddenActivationFunction or Functions.Sigmoid

    for _ = 1, arch.hiddenCount do
        perceptrons[#perceptrons+1] = Perceptron(arch.hidden, hiddenActFunc)
    end

    perceptrons[#perceptrons+1] = Perceptron(arch.output, arch.outputActivationFunction or Functions.Sigmoid)

    local kendra = Network(perceptrons)
    kendra.arch = arch
    return kendra
end

return CreateNetwork