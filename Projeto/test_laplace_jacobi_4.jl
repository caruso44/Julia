using Printf
using BenchmarkTools
using  Statistics
using DataFrames
using CSV
 
# Get the number of iterations from the command line.
 
n, = size(ARGS)
if n < 1
    println("Usage: fibonnaci.jl N")
    println("       ---> Please specify the number of iterations.")
    exit()
end
 
N = parse(Int, ARGS[1])
y = zeros(Int64, N, N)
 
 
"""
Regular jacobi algorithm
"""
function regular_time_step(u::Array{Int64, 2})
    n, m = size(u)
    error = 0.0
    for i in 2:n-1
        for j in 2:m-1
            temp = u[i, j]
            u[i, j] = ((u[i-1, j] + u[i+1, j] +
                       u[i, j-1] + u[i, j+1])*4.0 +
                       u[i-1, j-1] + u[i-1, j+1] +
                       u[i+1, j-1] + u[i+1, j+1])/20.0
 
            difference = u[i, j] - temp
            error = error + difference*difference
        end
    end
    return sqrt(error)
end
 
 
"""
Optimized Jacobi algorithm
"""
 
function optimized_time_step(u::Array{Int64, 2})
    n, m = size(u)
    error = 0
    @inbounds for i = 2:n-1
        for j = 2:m-1
            temp = u[j, i];
            u[j, i] = (u[j-1, i] + u[j+1, i] +
                        u[j, i-1] + u[j, i+1] +
                        u[j-1, i-1] + u[j+1, i+1] +
                        u[j+1, i-1] + u[j-1, i+1])
            difference = u[j, i] - temp
            error += difference*difference;
        end
    end
    return sqrt(error)
end
 
println("--------------------------")
println(@sprintf "Regular - Jacobi %d" N)
println("--------------------------")
 
u = ones
b = @benchmark regular_time_step(y) samples = 3 evals = 1 seconds = 10000
 
X = []
B = []
C = []
D = []
E = []

push!(X,"Laplace_Jacobi_" * string(N))
push!(B,mean(b.times)/1e9);
push!(C,minimum(b.times)/1e9);
push!(D,maximum(b.times)/1e9);
push!(E,std(b.times)/1e9);

 
println("")
println("--------------------------")
println(@sprintf "Optimized - Jacobi %d" N)
println("--------------------------")
 
b = @benchmark optimized_time_step(y) samples = 3 evals = 1 seconds = 10000


push!(X,"Laplace_Jacobi_" * string(N))
push!(B,mean(b.times)/1e9);
push!(C,minimum(b.times)/1e9);
push!(D,maximum(b.times)/1e9);
push!(E,std(b.times)/1e9);

df = DataFrame(function_name = X, avg_time = B, min_time = C, max_time = D, std_dev = E)
CSV.write("results-host-julia.csv", df, delim = ',', append = true)