using Printf
using BenchmarkTools
using Statistics
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

"""
recursive_fibonacci(n)
Finds the nth Fibonacci number using recursion.
"""
function recursive_fibonacci(n)
if n <= 2
        1.0
    else
        recursive_fibonacci(n-1) + recursive_fibonacci(n-2);
    end
end


"""
    iterative_fibonacci(n)
Finds the nth Fibonacci number using iteration.
"""
function iterative_fibonacci(n)
    x, y = (0, 1)
    for i = 1:n x, y = (y, x + y) end
    x
end


println("--------------------------")
println(@sprintf "Iterative - Fibonnaci %d" N)
println("--------------------------")

b = @benchmark iterative_fibonacci(N) samples = 3 evals = 1 seconds = 100000

A = []
B = []
C = []
D = []
E = []

push!(A,"iterative_fibonacci_" * string(N))
push!(B,mean(b.times)/1e9);
push!(C,minimum(b.times)/1e9);
push!(D,maximum(b.times)/1e9);
push!(E,std(b.times)/1e9);

# df = DataFrame(function_name = A, avg_time = B, min_time = C, max_time = D, std_dev = E)
# CSV.write("results-host-julia.csv", df,delim = ';',append=true)


println("")
println("--------------------------")
println(@sprintf "Recursive - Fibonnaci %d" N)
println("--------------------------")

b = @benchmark recursive_fibonacci(N) samples = 3 evals = 1 seconds = 100000

push!(A,"recursive_fibonacci_" * string(N))
push!(B,mean(b.times)/1e9);
push!(C,minimum(b.times)/1e9);
push!(D,maximum(b.times)/1e9);
push!(E,std(b.times)/1e9);

df = DataFrame(function_name = A, avg_time = B, min_time = C, max_time = D, std_dev = E)
CSV.write("results-host-julia.csv", df, delim = ',', append = true)



