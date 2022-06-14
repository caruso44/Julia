using Printf
using BenchmarkTools
using Statistics
using DataFrames
using CSV

println("-------------------------------")
println(@sprintf "Compute the first four Munchausen numbers")
println("-------------------------------")

"""
    raisedto(x)
Raise x to the power of itself.
"""
function raisedto(x)
    if x == 0
       return 0
    else
       return x^x
    end
end

function find_munchausen_numbers()

   power_of_digits = [raisedto(i) for i in 0:9]

   num = 0
   i = 0
   while num < 4
         thisnumber = i
         # find the sum of the digits raised to themselves
         sumofpowers = 0
         while thisnumber > 0
               digit = thisnumber % 10
               sumofpowers += power_of_digits[digit+1]
               thisnumber ÷= 10
         end
         if i == sumofpowers
            num += 1
            println("Munchausen number: ", num, " ", i)
         end
         i += 1
   end
end 


b = @benchmark find_munchausen_numbers() samples = 3 evals = 1 seconds = 100000

println(mean(b.times))
println(minimum(b.times))
println(maximum(b.times))
println(std(b.times))
println(" ")

A = []
B = []
C = []
D = []
E = []

push!(A,"munchausen")
push!(B,mean(b.times)/1e9);
push!(C,minimum(b.times)/1e9);
push!(D,maximum(b.times)/1e9);
push!(E,std(b.times)/1e9);

df = DataFrame(function_name = A, avg_time = B, min_time = C, max_time = D, std_dev = E)
CSV.write("results-host-julia.csv", df, delim = ',', append = true)