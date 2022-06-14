using Printf
using BenchmarkTools
using Statistics
using DataFrames
using CSV


# Get the matrix dimensions from the command line argument.
n, = size(ARGS)
if (n < 1)
    println("Usage: matrixMult.jl N")
    println("       ---> Please specify the dimensions.")
    exit()
end

N = parse(Int, ARGS[1])


println("----------------------------")
println(@sprintf "Matrix dimensions: %d" N)
println("----------------------------")
println(" ")

# Multiply matrices A and B.

A = randn(N, N)
B = randn(N, N)

b = @benchmark C = A*B samples = 3 evals = 1 seconds = 100000

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

push!(A,"matrix_multiplication_" * string(N))
push!(B,mean(b.times)/1e9);
push!(C,minimum(b.times)/1e9);
push!(D,maximum(b.times)/1e9);
push!(E,std(b.times)/1e9);

df = DataFrame(function_name = A, avg_time = B, min_time = C, max_time = D, std_dev = E)
CSV.write("results-host-julia.csv", df, delim = ',', append = true)

