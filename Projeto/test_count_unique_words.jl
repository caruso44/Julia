using Printf
using BenchmarkTools
using LegacyStrings

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
    println(wordlist)
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
b = @benchmark countwords(filename) samples = 3 evals = 1
io = IOBuffer()
show(io, "text/plain", b)
s = String(take!(io))

println(s)
println(" ")
