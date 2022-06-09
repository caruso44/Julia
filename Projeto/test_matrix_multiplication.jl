using Printf
using BenchmarkTools
using Statistics


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

b = @benchmark C = A*B samples = 3 evals = 1 seconds = 10000

println(mean(b.times))
println(minimum(b.times))
println(maximum(b.times))
println(std(b.times))
println(" ")



