#=
    matmulpar_test.jl
    Author: Ethan Garnier
    Class: CS4745
    Assignment: 2
=#
using Random, LinearAlgebra, BenchmarkTools
function matmulpar1_test(matSize, reps=1)
    for i in 1:reps
        # Create random nxn arrays
        a = rand(Float64, (matSize, matSize))
        b = rand(Float64, (matSize, matSize))
        c = zeros(Float64, (matSize, matSize))

        # debug
        # @show a b c

        print("matmulpar1!: ")
        @btime matmulpar1!($c, $a, $b)

        # Compute matrix product using Julia's implementation
        cc = a * b

        # Compare results
        diff = norm((cc - c) ./ c)

        print("Diff: $diff")
    end
end

function matmulpar2_test(matSize, cutoff, reps=1)
    for i in 1:reps
        # Create random nxn arrays
        a = rand(Float64, (matSize, matSize))
        b = rand(Float64, (matSize, matSize))
        c = zeros(Float64, (matSize, matSize))

        # debug
        # @show a b c

        print("matmulpar2!: ")
        @btime matmulpar2!($c, $a, $b, $cutoff)

        # Compute matrix product using Julia's implementation
        cc = a * b

        # Compare results
        diff = norm((cc - c) ./ c)

        print("Diff: $diff")
    end
end