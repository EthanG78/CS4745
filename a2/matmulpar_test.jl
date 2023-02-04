#=
    matmulpar_test.jl
    Author: Ethan Garnier
    Class: CS4745
    Assignment: 2
=#
using Random, LinearAlgebra, BenchmarkTools
function matmulpar_test(matSize, reps=1, method=matmulpar1!)
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

        # Temporary, just testing
        method(c, a, b)
        
        # Compute matrix product using Julia's implementation
        cc = a * b

        # Compare results
        diff = norm((cc-c)./c)

        print("Diff: $diff")
    end
end