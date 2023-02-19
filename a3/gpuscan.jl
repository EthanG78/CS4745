#=
    gpuscan.jl
    Author: Ethan Garnier
    Class: CS4745
    Assignment: 3
=#
using CUDA

function gpuscan_cuarray(a_d)
    n = length(a_d)
    j = 1
    @views @inbounds while j < n
        a_d[1+j:n] .= a_d[1+j:n] + a_d[1:n - j]
        j = j << 1
    end
    return a_d
end

function gpuscan_kernel(a_d)
    nothing
end