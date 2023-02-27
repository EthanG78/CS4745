#=
    gpuscan.jl
    Author: Ethan Garnier
    Class: CS4745
    Assignment: 3
=#
using CUDA

const MAX_THREADS_PER_BLOCK = CUDA.attribute(
    CUDA.CuDevice(0), CUDA.DEVICE_ATTRIBUTE_MAX_THREADS_PER_BLOCK,
)

function gpuscan_cuarray(a_d)
    n = length(a_d)
    j = 1
    @views @inbounds while j < n
        a_d[1+j:n] .= a_d[1+j:n] .+ a_d[1:n - j]
        j = j << 1
    end
    synchronize()
    return a_d
end

function gpuscan_cunative(a_d)
    n = length(a_d)
    j = 1
    nThreads = MAX_THREADS_PER_BLOCK
    nBlocks = cld(n, nThreads)
    # @show nThreads nBlocks
    while j < n
        @cuda blocks=nBlocks threads=nThreads gpuscan_kernel(a_d, j, n)
        j = j << 1
    end
    synchronize()
    return a_d
end

function gpuscan_kernel(a_d, j, n)
    i = (blockIdx().x - 1) * blockDim().x + threadIdx().x
    i += j  # 1+j <= i <= n
    if (i <= n)
        a_d[i] += a_d[i-j]
    end
    return nothing
end