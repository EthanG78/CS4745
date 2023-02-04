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

# TODO: BROKEN
# Fork-join matrix multiplication
#   - Each matrix is an nxn matrix
#   - Assume n is a power of two
function matmulpar2!(c, a, b, cutoff)
    if length(a) == 1 && length(b) == 1
        # Base case
        @views c[1, 1] += a[1 , 1] * b[1, 1]
    else
        # Divide a and b into 4 sub arrays of size (n/2)x(n/2)
        n::Int = size(a, 1) / 2
        for i in 1:2
            for j in 1:2
                # NOT WORKING
                a_new = @view a[(i*1):(i*n), (j*1):(j*n)]
                b_new = @view b[(i*1):(i*n), (j*1):(j*n)]

                print("$a_new\n")
                print("$b_new\n")
            end
        end
    end
    nothing
end