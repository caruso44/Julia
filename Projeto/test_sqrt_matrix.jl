using BenchmarkTools
using Printf
using Statistics
using DataFrames
using CSV

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

A = []
B = []
C = []
D = []
E = []

push!(A,"sqrt_matrix_" * string(N))
push!(B,mean(b.times)/1e9);
push!(C,minimum(b.times)/1e9);
push!(D,maximum(b.times)/1e9);
push!(E,std(b.times)/1e9);

df = DataFrame(function_name = A, avg_time = B, min_time = C, max_time = D, std_dev = E)
CSV.write("results-host-julia.csv", df, delim = ',', append = true)