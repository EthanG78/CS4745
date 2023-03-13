#=
    kmedianpar_test.jl
    Author: Ethan Garnier
    Class: CS4745
    Assignment: 4
=#
using Random, BenchmarkTools
function kmedianpar_test(n)
    print("kmedianpar\n")
    a = shuffle(1:n)
    for i in 1:n
        for j in 1:100
            ans = kmedianpar(a,i)
            if ans != i 
                print("i=$i, ans=$ans") 
                return
            end
        end
    end
    print("success")
end

function kmedian_time(n, reps=1)
    a = shuffle(1:n)
    for i in 1:reps
        k = rand(1:n)
        print("k=$k\n")
        print("kmedianpar: ")
        @btime kmedian3($a,$k)
    end
end
