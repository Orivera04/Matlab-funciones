function info=HeapManager(Action,ptr,info)
%HEAPMANAGER Private Heap Manager for pointers
%
%  INFO = HEAPMANAGER(ACTION, PTR, INFO)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.4.3 $  $Date: 2004/02/09 06:48:11 $

persistent MVHEAP USED_HEAP

if isempty(MVHEAP)
    MVHEAP = cell(1,2^10);
    USED_HEAP = [];
    mlock;
end

% Action codes:
%
%  0:  info
%  1:  infoarray
%  2:  set
%  3:  setarray
%  4:  new
%  5:  free
%  6:  clear
%  7:  save
%  8:  load
%  9:  isvalid

switch Action
    case 0
        if numel(ptr)==1
            if mbcbinsearch(USED_HEAP,ptr);
                info = MVHEAP{ptr};
            else
                error('mbc:xregpointer:InvalidPointerReference', 'Invalid Pointer.');
            end
        else
            % more than one pointer accessed (from info method)
            if all(mbcbinsearch(USED_HEAP,ptr))
                info = reshape(MVHEAP(ptr),size(ptr));
            else
                error('mbc:xregpointer:InvalidPointerReference', 'Invalid Pointers.');
            end
        end
    case 1
        if all(mbcbinsearch(USED_HEAP,ptr))
            info = reshape(MVHEAP(ptr),size(ptr));
        else
            error('mbc:xregpointer:InvalidPointerReference', 'Invalid Pointers.');
        end

    case 2
        if mbcbinsearch(USED_HEAP,ptr)
            MVHEAP{ptr} = info;
        else
            error('mbc:xregpointer:InvalidPointerReference', 'Invalid Pointer.');
        end
    case 4
        % Number of new pointers required is in argument 2.  New items to
        % store are optionally in argument 3.
        Nrequired = ptr;
        
        % How long is the heap
        N = length(USED_HEAP);
        if N == 0 || USED_HEAP(N) == N
            % No breaks in USED_HEAP so add to end of heap
            ptr = (N+1:N+Nrequired).';
            
            % Maintain a sorted heap list
            USED_HEAP = [USED_HEAP ; ptr];
        else
            % Start looking for spaces at the beginning
            ptr = zeros(Nrequired, 1);
            NEW_USED_HEAP = zeros(N + Nrequired, 1);
            
            % Sweep through the USED_HEAP list to look for gaps
            ptrIdx = 1;
            heapIdx = 1;
            usedIdx = 1;
            while ptrIdx<=Nrequired && usedIdx<=N
                NEW_USED_HEAP(heapIdx) = heapIdx;
                if heapIdx==USED_HEAP(usedIdx)
                    heapIdx = heapIdx + 1;
                    usedIdx = usedIdx + 1;
                else
                    ptr(ptrIdx) = heapIdx;
                    ptrIdx = ptrIdx + 1;
                    heapIdx = heapIdx + 1;
                end
            end
            
            % Add any remaining new pointers to the end of the heap
            if ptrIdx<=Nrequired
                ptr(ptrIdx:end) = heapIdx:(heapIdx+Nrequired-ptrIdx);
                NEW_USED_HEAP(heapIdx:end) = heapIdx:(heapIdx+Nrequired-ptrIdx);
            else
                NEW_USED_HEAP(heapIdx:end) = USED_HEAP(usedIdx:end);
            end 
            USED_HEAP = NEW_USED_HEAP;
        end

        % Check that the heap is large enough to accomodate the new
        % data
        while ptr(end) > length(MVHEAP)
            % Add another 1024 elements to heap
            MVHEAP = [MVHEAP cell(1, 1024)];
        end
        
        if nargin > 2
            % assign new info to heap
            MVHEAP(ptr) = info;
        end
        
        % Return heap location of new items
        info = ptr;
    case 5
        f = mbcbinsearch(USED_HEAP,ptr);

        if ~all(f)
            warning('mbc:xregpointer:InvalidPointerReference', 'Freeing invalid pointer(s).');
            f(~f) = [];
        end

        % temp copy of old heap so you can do internal free
        OldHeap = MVHEAP(ptr);

        % free heap
        USED_HEAP(f,:) = [];
        MVHEAP(ptr) = {[]};
        % recursive free
        for i = 1:length(OldHeap)
            freeptr(OldHeap{i});
        end
    case 3
        if all(mbcbinsearch(USED_HEAP,ptr))
            MVHEAP(ptr) = info;
        else
            error('mbc:xregpointer:InvalidPointerReference', 'Invalid Pointers.');
        end

    case 6
        MVHEAP = [];
        USED_HEAP = [];
    case 7
        Heap.MVHEAP = MVHEAP;
        Heap.USED_HEAP = USED_HEAP;
        info = Heap;
    case 8
        Heap = ptr;
        MVHEAP = Heap.MVHEAP;
        USED_HEAP = Heap.USED_HEAP;
    case 9
        % checks if pointer is valid
        info = (mbcbinsearch(USED_HEAP,ptr)~=0);
    otherwise
        error('mbc:xregpointer:InvalidPArgument', 'Unknown HeapManager Action.');
end
