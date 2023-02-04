#=
    matmulpar.jl
    Author: Ethan Garnier
    Class: CS4745
    Assignment: 2
=#
using Base.Threads

# Naive matrix multiplication using nested loops
function matmulpar1!(c, a, b)
    @threads for i in axes(a, 1)
        for j in axes(b, 2)
            for k in axes(b, 1)
                c[i, j] += a[i, k] * b[k, j]
            end 
        end
    end
    nothing
end

function matmulpar2!(c, a, b, cutoff)
end