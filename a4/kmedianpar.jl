#=
    kmedianpar.jl
    Author: Ethan Garnier
    Class: CS4745
    Assignment: 4
=#
using Base.Threads

function kmedianpar(ain, k)
    if k > lastindex(ain) return -1 end
    a = copy(ain)
    acopy = similar(a)
    return kmedianrec!(a, acopy, 1, length(a), k)
end

function kmedianrec!(a, acopy, lo, hi, k)
    ipivot = rand(lo:hi)
    p = a[ipivot]
    sizeL, idxH = partition!(a, acopy, lo, hi, ipivot)
    if sizeL == k - 1 return p end
    if sizeL >= k return kmedianrec!(acopy, a, lo , lo + sizeL - 1, k) end
    return kmedianrec!(acopy, a, idxH, hi, k - sizeL - 1)
end

# TODO: THIS HAS NOT BEEN TESTED
function partition!(a, acopy, lo, hi, ipivot)
    a[lo], a[ipivot] = a[ipivot], a[lo]

    p = a[lo]

    if lo + 1 > hi return hi - lo, hi end

    # Populate the marker arrays
    markerL = similar(lo:hi-1)
    markerH = similar(lo:hi-1)
    @threads for i in lo:hi-1
        if a[i] < p
            markerL[i] = 1
            markerH[i] = 0
        else
            markerL[i] = 0
            markerH[i] = 1
        end
    end

    pSumL = cumsum(markerL)
    pSumH = cumsum(markerH)

    sizeL = findmax(pSumL)

    # Use the prefix sums to properly place values
    # from a into acopy based on if they are in L or H
    @threads for i in lo:hi-1
        if markerL[i] == 1
            acopy[pSumL[i]] = a[i]
        else
            acopy[pSumH[sizeL + i]] = a[i]
        end
    end



    # TODO:
    #return j - lo, j + 1
    return 1, 1
end