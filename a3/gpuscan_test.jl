#=
    gpuscan_test.jl
    Author: Ethan Garnier
    Class: CS4745
    Assignment: 3
=#
using CUDA

function testfn(a, fn)
    a_d = CuArray{eltype(a)}(a)
    println(fn)
    CUDA.@time r_d = fn(a_d)
    r = Array(r_d)
    ps = cumsum(a)
    println(ps == r)
    1
end