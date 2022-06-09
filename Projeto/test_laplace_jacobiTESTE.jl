using Printf
using BenchmarkTools
using  Statistics

# Get the number of iterations from the command line.

n, = size(ARGS)
if n < 1
    println("Usage: fibonnaci.jl N")
    println("       ---> Please specify the number of iterations.")
    exit()
end

N = parse(Int, ARGS[1])

"""
Regular jacobi algorithm
"""
function regular_time_step(u::Matrix)
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

function optimized_time_step(u::Matrix{T})  where {T}
    n, m = size(u)
    error = T(0.0) # not an optimization, but makes it work for all element types
    @inbounds for i = 2:n-1
        for j = 2:m-1
            temp = u[j, i];
            u[j, i] = ( T(4) *(u[j-1, i] + u[j+1, i] +
                        u[j, i-1] + u[j, i+1]) +
                        u[j-1, i-1] + u[j+1, i+1] +
                        u[j+1, i-1] + u[j-1, i+1]) / T(20)
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
b = @benchmark regular_time_step(u) samples = 3 evals = 1 seconds = 10000

println(mean(b.times))
println(minimum(b.times))
println(maximum(b.times))
println(std(b.times))
println(" ")


println("")
println("--------------------------")
println(@sprintf "Optimized - Jacobi %d" N)
println("--------------------------")

b = @benchmark optimized_time_step(u) samples = 3 evals = 1 seconds = 10000
 
println(mean(b.times))
println(minimum(b.times))
println(maximum(b.times))
println(std(b.times))
println(" ")

