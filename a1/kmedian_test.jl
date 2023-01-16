using Random, BenchmarkTools
function kmedian_test(n, method=kmedian)
    print(method,"\n")
    a = shuffle(1:n)
    for i in 1:n
        for j in 1:100
            ans = method(a,i)
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
        print("kmedian: ")
        @btime kmedian($a,$k)
        print("kmedian2: ")
        @btime kmedian2($a,$k)
        print("kmedian3: ")
        @btime kmedian3($a,$k)
    end
end
