# Elements of a are distinct

using Base.Threads

# First version - in place partitioning
function kmedian(ain, k) 
    if k > lastindex(ain) return -1 end
    a = copy(ain)
    return kmedianrec!(a, 1, lastindex(a), k)
end

function kmedianrec!(a, lo, hi, k)
    #@show a, lo, hi
    ipivot = rand(lo:hi)
    p = a[ipivot]
    size = partition!(a, ipivot, lo, hi)
    if size == k-1 return p end
    if size >= k return kmedianrec!(a, lo+1, size+lo, k) end
    return kmedianrec!(a, size+lo+1, hi, k-size-1)
end

function partition!(a, ipivot, lo, hi)
    a[lo],a[ipivot] = a[ipivot],a[lo]
    p = a[lo]
    i = lo + 1
    j = hi
    if i>hi return j-lo end
    while true 
        while a[i] < p
            i += 1
            if i >= hi break end
        end
        while a[j] > p
            j -= 1
            if j <= lo break end
        end
        if i >= j break end
        a[i],a[j] = a[j],a[i]
    end
    return j-lo
end

# Second version - partitioning with temporary arrays

function kmedian2(a, k)
    if k > lastindex(a) return -1 end
    return kmedianrec(a, k)
end

function kmedianrec(a, k)
    ipivot = rand(1:length(a))
    p,L,H = partition(a, ipivot)
    size = length(L)
    if size == k-1 return p end
    if size >= k return kmedianrec(L, k) end
    return kmedianrec(H, k-size-1)
end

function partition(a, ipivot)
    L = similar(a,0)
    H = similar(a,0)
    p = a[ipivot]
    for i in 1:length(a)
        if i == ipivot continue end
        if a[i] < p 
            push!(L, a[i])
        else
            push!(H, a[i])
        end
    end
    return p, L, H
end

# Third version - partitioning with scratch array

function kmedian3(ain, k)
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

function partition!(a, acopy, lo, hi, ipivot)
    a[lo], a[ipivot] = a[ipivot], a[lo]

    p = a[lo]
    i = lo
    j = hi

    if lo + 1 > hi return hi - lo, hi end

    for x in a[lo + 1:hi]
        if x < p
            acopy[i] = x
            i += 1
        else
            acopy[j] = x
            j -= 1
        end
    end

    return j - lo, j + 1
end