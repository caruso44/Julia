"""
  Compute the nth Pernicious number
"""

using BenchmarkTools
using Printf
using Primes
using Statistics
using DataFrames
using CSV

# Get the value of of an integer from the command line.
n, = size(ARGS)
if n < 1
    println("Usage: test_pernicious_numbers.jl max_num")
    println("       --->      Please specify a positive integer.")
    exit()
end

max_num = parse(Int64, ARGS[1])

 
ispernicious(n::Int64) = isprime(count_ones(n))

nextpernicious(n::Int64) = begin n += 1; while !ispernicious(n) n += 1 end; return n end

function perniciouses(n::Int64)
    rst = Vector{Int64}(undef, n)
    old_p = 3
    for i in 2:n
        new_p = nextpernicious(old_p)
        old_p = new_p
    end
    return old_p
end

perniciouses(a::Integer, b::Integer) = filter(ispernicious, a:b)

println("Pernicious number of order: ", max_num)

b = @benchmark perniciouses(max_num) samples = 3 evals = 1 seconds = 10000

println(mean(b.times))
println(minimum(b.times))
println(maximum(b.times))
println(std(b.times))
println(" ")

#println("Pernicious number of order ", max_num, ": ", perniciouses(max_num))

A = []
B = []
C = []
D = []
E = []

push!(A,"pernicious_numbers_" * string(max_num))
push!(B,mean(b.times)/1e9);
push!(C,minimum(b.times)/1e9);
push!(D,maximum(b.times)/1e9);
push!(E,std(b.times)/1e9);

df = DataFrame(function_name = A, avg_time = B, min_time = C, max_time = D, std_dev = E)
CSV.write("results-host-julia.csv", df, delim = ',', append = true)