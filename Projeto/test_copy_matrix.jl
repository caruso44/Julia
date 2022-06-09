using Statistics
using BenchmarkTools
using Printf


# Get the dimension from the command line.
n, = size(ARGS)
if n < 1
    println("Usage: copyMatrix.jl dim")
    println("       --->      Please specify the dimension.")
    exit()
end

dimension = parse(Int, ARGS[1])

"""
    maxtrixcopy(A)
Perform the copy operations on matrix A with the given dimensions.
"""
function matrixcopy(A)
    N = size(A, 1)
    for j = 1:N, i = 1:N
        A[i, j, 1] = A[i, j, 2]
        A[i, j, 3] = A[i, j, 1]
        A[i, j, 2] = A[i, j, 3]
    end 
end


println("-------------------------------")
println(@sprintf "Copy of matrix (loop) %d" dimension)
println("-------------------------------")

A = randn(dimension, dimension, 3)

b = @benchmark matrixcopy(A) samples = 3 evals = 1 seconds = 10000

println(mean(b.times))
println(minimum(b.times))
println(maximum(b.times))
println(std(b.times))
println(" ")

println("--------------------------")
println(@sprintf "Vectorized Copy of matrix %d" dimension)
println("--------------------------")

A = randn(dimension, dimension, 3)

b = @benchmark begin
    A[:, :, 1] = A[:, :, 2]
    A[:, :, 3] = A[:, :, 1]
    A[:, :, 2] = A[:, :, 3]
end samples = 3 evals = 1 seconds = 10000

