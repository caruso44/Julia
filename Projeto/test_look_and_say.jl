using BenchmarkTools
using Printf


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
end samples = 3 evals = 1


io = IOBuffer()
show(io, "text/plain", b)
s = String(take!(io))

println(s)

#   println(r)