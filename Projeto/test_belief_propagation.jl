using BenchmarkTools
using Printf
using Random
using LinearAlgebra
using Statistics

# Get the number of iterations from the command line.
n, = size(ARGS)
if n < 1
    println("Usage: belief.jl N")
    println("       ---> Please specify the number of iterations.")
    exit()
end

N = parse(Int, ARGS[1])

"""
    beliefpropagation(N)
Runs the belief propagation algorithm N times.
"""
function beliefpropagation(N)
    dim = 5000
    x = ones(dim)
    A = (randn(dim,dim) .+ 1.0)/2.0

    for i = 1:N
        x = log.(A*exp.(x));
        x .-= log.(sum(exp.(x)));
    end
    x
end

println("--------------------------")
println(@sprintf "Belief calculations: %d" N)
println("--------------------------")

b = @benchmark beliefpropagation(N) samples = 3 evals = 1 seconds = 10000

println(mean(b.times))
println(minimum(b.times))
println(maximum(b.times))
println(std(b.times))
println(" ")
