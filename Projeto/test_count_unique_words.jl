using Printf
using BenchmarkTools
using LegacyStrings
using Statistics
using DataFrames
using CSV

punctuation_characters = r"[~\`!@#\$%^&*()_\-\+\\|;:',<.>\/?1234567890]"
#punctuation_characters = String("~\`!@#\$%^&*()_\-\+\\|;:',<.>\/?1234567890")
#punctuation_characters = ASCIIString("~\`!@#$%^&*()_-+=[{]}\\|;:',<.>/?1234567890")
#punctuation_characters = '!"#$%&\'()*+,-./:;<=>?@[\\]^_`{|}~ \t\n\r\x0b\x0c'

"""
    countwords(filename::String)
Opens the given file and makes a collection of its unique words.
"""
function countwords(filename::String)
    openedfile = open(filename)
    wordlist = Set()
    for line in eachline(openedfile)
        words = split( replace(lowercase(line), punctuation_characters=>""))
        for word in words
            push!(wordlist, word)
        end
    end
    close(openedfile)
    filter!(!isempty, wordlist)
    println("Number of unique words: ", length(wordlist))
end


# Get the text file name from the command line.
n, = size(ARGS)
if n < 1
    println("Usage: ")
    println("    julia " + ARG[0] + " filename")
    println("       --->      Please specify the filename.")
    exit()
end

filename = ARGS[1]
b = @benchmark countwords(filename) samples = 3 evals = 1 seconds = 100000
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

push!(A,"count_words_" * filename)
push!(B,mean(b.times)/1e9);
push!(C,minimum(b.times)/1e9);
push!(D,maximum(b.times)/1e9);
push!(E,std(b.times)/1e9);

df = DataFrame(function_name = A, avg_time = B, min_time = C, max_time = D, std_dev = E)
CSV.write("results-host-julia.csv", df, delim = ',', append = true)