using BenchmarkTools
using Printf
using FFTW


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
end samples = 3 evals = 1


io = IOBuffer()
show(io, "text/plain", b)
s = String(take!(io))

println(s)
