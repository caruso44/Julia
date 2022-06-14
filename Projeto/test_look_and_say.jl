using BenchmarkTools
using Printf
using Statistics
using DataFrames
using CSV


"""
    look_and_say_sequence(startsequence, n)
Construct the look and say sequence of order n and starting sequence startsequence.
"""
#function look_and_say_sequence(startsequence::String, n::Integer)
function look_and_say_sequence(startsequence, n)
    currentsequence = startsequence

    i = 2

    while i <= n
        count = 1
        tempseries = ""
        for j in 2:length(currentsequence)
            if currentsequence[j] == currentsequence[j-1]
                count += 1
            else
                tempseries = string(tempseries, count, currentsequence[j-1])
                count = 1
            end
        end
        tempseries = string(tempseries, count, currentsequence[length(currentsequence)])
        currentsequence = tempseries
        i += 1
    end
    return currentsequence
end


N = parse(Int, ARGS[1])

println("--------------------------")
println(@sprintf "Look and say sequence: %d" N)
println("--------------------------")

b = @benchmark begin
    r = look_and_say_sequence("1223334444", N)
end samples = 3 evals = 1 seconds = 100000


println(mean(b.times))
println(minimum(b.times))
println(maximum(b.times))
println(std(b.times))
println(" ")
#   println(r)

A = []
B = []
C = []
D = []
E = []

push!(A,"look_and_say_" * string(N))
push!(B,mean(b.times)/1e9);
push!(C,minimum(b.times)/1e9);
push!(D,maximum(b.times)/1e9);
push!(E,std(b.times)/1e9);

df = DataFrame(function_name = A, avg_time = B, min_time = C, max_time = D, std_dev = E)
CSV.write("results-host-julia.csv", df, delim = ',', append = true)