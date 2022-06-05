using BenchmarkTools
using Printf
using Random

# Get the number of iterations from the command line
n, = size(ARGS)
if (n < 1)
    println("Usage: test_markov_chain.jl N")
    println("       ---> Please specify the number of iterations.")
    exit()
end

N = parse(Int, ARGS[1])



"""
    function markov(x, y, N)
Operate the Markov chain on two inputs x, y a total of N times.
"""
function markov(x, y, N)
    f(x, y) = exp(sin(x*5) - x^2 - y^2)    
    p = f(x, y)
    for n = 1:N
        x2 = x + 0.01*randn()
        y2 = y + 0.01*randn()
        p2 = f(x2, y2)
        if rand() < p2/p
            x = x2
            y = y2
            p = p2
        end
    end
    x, y
end

# trigger JIT
markov(0.0, 0.0, 10)

println("--------------------------")
println(@sprintf "Markov Chain calculations: %d" N)
println("--------------------------")

b = @benchmark markov(0.0, 0.0, N) samples = 3 evals = 1

io = IOBuffer()
show(io, "text/plain", b)
s = String(take!(io))

println(s)


