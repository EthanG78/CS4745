#=
    kmedianpar.jl
    Author: Ethan Garnier
    Class: CS4745
    Assignment: 4
=#
using Base.Threads

function kmedianpar(ain, k)
    if k > lastindex(ain)
        return -1
    end
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

# BROKEN
function partition!(a, acopy, lo, hi, ipivot)
    a[lo], a[ipivot] = a[ipivot], a[lo]

    p = a[lo]

    if lo + 1 > hi return 1 end

    # Populate the marker arrays
    markerL = similar(lo+1:hi)
    markerH = similar(lo+1:hi)
    @threads for i in lo+1:hi
        if a[i] < p
            markerL[i-1] = 1
            markerH[i-1] = 0
        else
            markerL[i-1] = 0
            markerH[i-1] = 1
        end
    end

    # Calculate the prefix sum of the marker arrays
    # to determine where to place values in acopy
    pSumL = cumsum(markerL)
    pSumH = cumsum(markerH)

    # The maximum value in the prefix sum of the L marker
    # array tells us how big the L subset is.
    sizeL = maximum(pSumL)

    # Use the prefix sums to properly place values
    # from a into acopy based on if they are in L or H
    @threads for i in lo+1:hi
        if markerL[i-1] == 1
            acopy[pSumL[i-1]] = a[i]
        else
            acopy[sizeL+pSumH[i-1]] = a[i]
        end
    end

    # debug
    # @show a, acopy, markerL, markerH, pSumH, pSumL, sizeL

    return sizeL
end