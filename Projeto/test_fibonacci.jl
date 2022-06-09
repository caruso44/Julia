using Printf
using BenchmarkTools
using  Statistics
using  DataFrames

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

b = @benchmark iterative_fibonacci(N) samples = 3 evals = 1 seconds = 10000

println(mean(b.times))
println(minimum(b.times))
println(maximum(b.times))
println(std(b.times))
println(" ")


println("")
println("--------------------------")
println(@sprintf "Recursive - Fibonnaci %d" N)
println("--------------------------")

b = @benchmark recursive_fibonacci(N) samples = 3 evals = 1 seconds = 10000
 
df  = DataFrame[("recursive fibonacci", mean(b.times), minimum(b.times), maximum(b.times), std(b.times))]



