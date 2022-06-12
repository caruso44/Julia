using BenchmarkTools
using Printf
using FFTW
using Statistics
using DataFrames
using CSV

# Get the number of data points N from the command line.
N = parse(Int, ARGS[1])

println("-----------------------------------------")
println("Compute FFTs: ", N)
println("-----------------------------------------")
println(" ")

#Take the FFT of the N random data points.
b = @benchmark  begin
    mat = complex.(rand(N, N), randn(N, N))
    result = fft(mat)
    result = abs.(result)
end samples = 3 evals = 1 seconds = 100000

A = []
B = []
C = []
D = []
E = []

push!(A,"compute_FFT_" * string(N))
push!(B,mean(b.times)/1e9);
push!(C,minimum(b.times)/1e9);
push!(D,maximum(b.times)/1e9);
push!(E,std(b.times)/1e9);

df = DataFrame(function_name = A, avg_time = B, min_time = C, max_time = D, std_dev = E)
CSV.write("results-host-julia.csv", df, delim = ',', append = true)