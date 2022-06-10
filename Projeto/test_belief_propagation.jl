using BenchmarkTools
using Printf
using Random
using LinearAlgebra
using Statistics
using DataFrames
using CSV

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

A = []
B = []
C = []
D = []
E = []

push!(A,"belief_propagation_" * string(N))
push!(B,mean(b.times)/1e9);
push!(C,minimum(b.times)/1e9);
push!(D,maximum(b.times)/1e9);
push!(E,std(b.times)/1e9);

df = DataFrame(function_name = A, avg_time = B, min_time = C, max_time = D, std_dev = E)
CSV.write("results-host-julia.csv", df, delim = ',', append = true)