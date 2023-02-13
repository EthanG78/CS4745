#=
    matmulpar_test.jl
    Author: Ethan Garnier
    Class: CS4745
    Assignment: 2
=#
using Random, LinearAlgebra, BenchmarkTools
function matmulpar1_test(matSize, reps=1)
    for i in 1:reps
        # Generate random sizes of random arrays
        m = rand(1:matSize)
        n = rand(1:matSize)
        p = rand(1:matSize)

        # Array a is mxn
        a = rand(Float64, (m, n))

        # Array b is nxp
        b = rand(Float64, (n, p))

        # Array c is mxp
        c = zeros(Float64, m, p)

        # debug
        # @show a b c

        print("matmulpar1!: ")
        @btime matmulpar1!($c, $a, $b)
        
        # Compute matrix product using Julia's implementation
        cc = a * b

        # Compare results
        diff = norm((cc-c)./c)

        print("Diff: $diff")
    end
end

function matmulpar2_test(matSize, cutoff, reps=1)
    for i in 1:reps
        # Generate random sizes of random arrays
        n = rand(1:matSize)

        # Create random nxn arrays
        a = rand(Float64, (n, n))
        b = rand(Float64, (n, n))
        c = zeros(Float64, n, n)

        # debug
        # @show a b c

        # Temporary, just testing
        print("matmulpar2!: ")
        @btime matmulpar2!($c, $a, $b, $cutoff)
        
        # Compute matrix product using Julia's implementation
        cc = a * b

        # Compare results
        diff = norm((cc-c)./c)

        print("Diff: $diff")
    end
end