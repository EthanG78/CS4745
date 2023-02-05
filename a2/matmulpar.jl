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
        @views c[1, 1] += a[1, 1] * b[1, 1]
    else
        # Divide a, b, and c into 4 sub arrays of size (n/2)x(n/2)
        n::Int = size(a, 1)
        m::Int = floor(n / 2)
        @views begin
            a11 = a[1:m, 1:m]
            a12 = a[1:m, m+1:n]
            a21 = a[m+1:n, 1:m]
            a22 = a[m+1:n, m+1:n]

            b11 = b[1:m, 1:m]
            b12 = b[1:m, m+1:n]
            b21 = b[m+1:n, 1:m]
            b22 = b[m+1:n, m+1:n]

            c11 = c[1:m, 1:m]
            c12 = c[1:m, m+1:n]
            c21 = c[m+1:n, 1:m]
            c22 = c[m+1:n, m+1:n]
        end

        
    end
    nothing
end