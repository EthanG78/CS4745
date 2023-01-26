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
    # BROKEN
    if sizeL == k - 1 return p end
    if sizeL >= k return kmedianrec!(acopy, a, lo , lo + sizeL - 1, k) end
    return kmedianrec!(acopy, a, idxH, hi, k - sizeL - 1)
end

function partition!(a, acopy, lo, hi, ipivot)
    #=sizeL = partition!(a, ipivot, lo, hi)
    acopy[lo] = a[lo]
    acopy[lo + 1:lo + sizeL] = a[lo + 1:lo + sizeL]
    acopy[lo + sizeL: hi] = reverse(a[lo + sizeL: hi])=#

    #=
        From assignment doc:
        
        The partition!() function partitions a into acopy by placing L at the beginning of the array
        and H in reverse order at the end of the array. For example, if a=[3,7,4,2,5] and p is 4, then
        acopy=[3,2,?,5,7], where the middle element of acopy is unused. Hint: it is useful to swap p with
        the first element of a before partitioning into acopy in order to avoid having to skip p in the loop.
    
        Therefore I need to have the pivot be in the middle, not the start??
    =#

    a[lo], a[ipivot] = a[ipivot], a[lo]
    
    p = a[lo]
    i = lo + 1
    j = hi

    # todo:
    #   - How can we find the index of H for this edge case?
    #   - This edge case only happens when lo + 1 > hi 
    #     so |L| = 1 and starting idx of |H| is ? hi?
    if i > hi
        # @show i j lo hi
        # acopy = a
        return j - lo, hi 
    end

    while true 
        while a[i] < p
            acopy[i] = a[i]
            i += 1
            if i >= hi break end
        end
        while a[j] > p
            acopy[j] = a[j]
            j -= 1
            if j <= lo break end
        end
        if i >= j break end
        a[i], a[j] = a[j],a[i]
    end

    acopy[lo], acopy[j] = acopy[j], p 

    return j - lo, j + 1
end




