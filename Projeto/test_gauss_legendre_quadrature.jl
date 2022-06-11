using BenchmarkTools
using Printf
using LinearAlgebra
using Statistics
using DataFrames
using CSV

# Get the number of iterations from the command line
n, = size(ARGS)
if n < 1
    println("Usage: TestGaussLegendreQuadrature.jl N")
    println("       ---> Please specify the number of grid points.")
    exit()
end

N = parse(Int, ARGS[1])

"""
    gauss(a, b, N)
Finds the approximate integral over the region [a, b]
with N iterations.
"""
function gauss(a, b, N)
    F = eigen(SymTridiagonal(zeros(N), [n/sqrt(4n^2 - 1) for n = 1:N-1]))
    return [(F.values[i]+1)*(b-a)/2 + a for i = 1:N], [2*F.vectors[1, i]^2 for i = 1:N]*(b-a)/2
    #lambda, Q = eig(SymTridiagonal(zeros(N), [n/sqrt(4n^2 - 1) for n = 1:N-1]))
    #return (lambda+1)*(b-a)/2 + a, [2*Q[1, i]^2 for i = 1:N]*(b-a)/2
end


println("--------------------------")
println(@sprintf "Gauss-Legendre Quadrature %d" N)
println("--------------------------")

b = @benchmark begin
   x, w = gauss(-3, 3, $N)
   quad = sum(exp.(x) .* w)
end samples = 3 evals = 1 seconds = 10000

println(mean(b.times))
println(minimum(b.times))
println(maximum(b.times))
println(std(b.times))
println(" ")

#exact = exp(3) - exp(-3)
#println(quad)
#println(exact)

A = []
B = []
C = []
D = []
E = []

push!(A,"gauss_legendre_" * string(N))
push!(B,mean(b.times)/1e9);
push!(C,minimum(b.times)/1e9);
push!(D,maximum(b.times)/1e9);
push!(E,std(b.times)/1e9);

df = DataFrame(function_name = A, avg_time = B, min_time = C, max_time = D, std_dev = E)
CSV.write("results-host-julia.csv", df, delim = ',', append = true)