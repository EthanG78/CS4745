#=
    kmedianpar.jl
    Author: Ethan Garnier
    Class: CS4745
    Assignment: 4
=#
using Base.Threads

const N_THREADS = Threads.nthreads()

function kmedianpar(ain, k)
    if k > lastindex(ain) return -1 end
    a = copy(ain)
    acopy = similar(a)
    return kmedianrec!(a, acopy, 1, length(a), k)
end

function kmedianrec!(a, acopy, lo, hi, k)
    ipivot = rand(lo:hi)
    p = a[ipivot]
    sizeL = partition!(a, acopy, lo, hi, ipivot)
    if sizeL == k - 1 return p end
    if sizeL >= k return kmedianrec!(acopy, a, lo, lo + sizeL - 1, k) end
    return kmedianrec!(acopy, a, lo + sizeL, hi - 1, k - sizeL - 1)
end

function partition!(a, acopy, lo, hi, ipivot)
    a[lo], a[ipivot] = a[ipivot], a[lo]

    p = a[lo]

    if lo + 1 > hi return hi - lo end

    # Populate the marker arrays
    markerSize = hi-lo
    markerL = zeros(Int64, markerSize)
    markerH = ones(Int64, markerSize)

    # Determine the size of work each thread will perform
    chunkS = cld(markerSize, N_THREADS)

    @threads for i in 1:N_THREADS
        jstart = (i-1) * chunkS + 1
        jend = i * chunkS
        jend = (jend > markerSize) ? markerSize : jend
        for j in jstart:jend
            if a[lo+j] < p
                markerL[j] = 1
                markerH[j] = 0
            end
        end
    end

    # Calculate the prefix sum of the marker arrays
    # to determine where to place values in acopy
    pSumL = cumsum(markerL)
    pSumH = cumsum(markerH)

    # The last value in the prefix sum of the L marker
    # array tells us how big the L subset it.
    sizeL = last(pSumL) 

    # Use the prefix sums to properly place values
    # from a into acopy based on if they are in L or H
    @threads for i in 1:N_THREADS
        jstart = (i-1) * chunkS + 1
        jend = i * chunkS
        jend = (jend > markerSize) ? markerSize : jend
        for j in jstart:jend
            if markerL[j] == 1
                acopy[lo-1+pSumL[j]] = a[lo+j]
            else
                acopy[lo-1+sizeL+pSumH[j]] = a[lo+j]
            end
        end
    end

    return sizeL
end