using BenchmarkTools
using Printf
using Random
using Statistics
using DataFrames
using CSV

# Get the number of iterations from the command line
n, = size(ARGS)
if (n < 1)
    println("Usage: test_markov_chain.jl N")
    println("       ---> Please specify the number of iterations.")
    exit()
end

N = parse(Int, ARGS[1])



"""
    function markov(x, y, N)
Operate the Markov chain on two inputs x, y a total of N times.
"""
function markov(x, y, N)
    f(x, y) = exp(sin(x*5) - x^2 - y^2)    
    p = f(x, y)
    for n = 1:N
        x2 = x + 0.01*randn()
        y2 = y + 0.01*randn()
        p2 = f(x2, y2)
        if rand() < p2/p
            x = x2
            y = y2
            p = p2
        end
    end
    x, y
end

# trigger JIT
markov(0.0, 0.0, 10)

println("--------------------------")
println(@sprintf "Markov Chain calculations: %d" N)
println("--------------------------")

b = @benchmark markov(0.0, 0.0, N) samples = 3 evals = 1 seconds = 10000

println(mean(b.times))
println(minimum(b.times))
println(maximum(b.times))
println(std(b.times))
println(" ")

A = []
B = []
C = []
D = []
E = []

push!(A,"markov_chain_" * string(N))
push!(B,mean(b.times)/1e9);
push!(C,minimum(b.times)/1e9);
push!(D,maximum(b.times)/1e9);
push!(E,std(b.times)/1e9);

df = DataFrame(function_name = A, avg_time = B, min_time = C, max_time = D, std_dev = E)
CSV.write("results-host-julia.csv", df, delim = ',', append = true)