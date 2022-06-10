using BenchmarkTools
using Printf
using Statistics

# Get the matrix dimensions N from the command line argument.
N = parse(Int, ARGS[1])

A = ones(N, N)
for i = 1:N
    A[i, i] = 6
end

println("--------------------------")
println(@sprintf "Matrix square root: %d" N)
println("--------------------------")

# Take the square root of matrix A.
b = @benchmark begin
    B = sqrt(A)
end samples = 3 evals = 1 seconds = 10000

println(mean(b.times))
println(minimum(b.times))
println(maximum(b.times))
println(std(b.times))
println(" ")
