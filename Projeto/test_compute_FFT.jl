using BenchmarkTools
using Printf
using FFTW
using Statistics


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
end samples = 3 evals = 1 seconds = 10000


println(mean(b.times))
println(minimum(b.times))
println(maximum(b.times))
println(std(b.times))
println(" ")