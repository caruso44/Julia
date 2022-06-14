using Printf

n, = size(ARGS)
if n < 1
    println("Usage: belief.jl N")
    println("       ---> Please specify the number of iterations.")
    exit()
end

Nbegin = parse(Float64, ARGS[1])
Nend = parse(Float64, ARGS[2])

file = open("Tempo.txt", "w")

x = (Nend - Nbegin)/1e9

tempo = @sprintf("%5.3f",x)

write(file, tempo)