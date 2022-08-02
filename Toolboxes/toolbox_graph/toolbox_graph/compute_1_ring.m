function vring = compute_1_ring(face)

% compute_1_ring - compute the 1 ring of each vertex in a triangulation.
%
%   vring = compute_1_ring(face);
%
%   vring{i} is the set of vertices that are adjacent
%   to vertex i.
%
%   Copyright (c) 2004 Gabriel Peyré

if size(face,2)>size(face,1)
    face = face';
end

nface = size(face,1);
nvert = max(max(face));

% create empty list
for i=1:nvert
    vring{i} = []; 
end

% assert each face is in increasing order
for i=1:nface
    face(i,:) = sort(face(i,:));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       VERTEX RING

% first compute the 1 vring not in 
% corect order
for i=1:nface
    f = face(i,:);
    for j=1:3
        k = f(j);
        r = vring{k};
        k1 = f( mod(j,3)+1 );
        k2 = f( mod(j-2,3)+1 );
        if isempty(find(r==k1))
            r = [r k1];
        end
        if isempty(find(r==k2))
            r = [r k2];
        end
        vring{k} = r;
    end
end

h = waitbar(0,'Computing Vertex 1-ring');
% sort 1 ring in circular order
for i=1:nvert
    waitbar(i/nvert)
    r = vring{i};
    
    % pop 1st vertex
    gche = r(1);
    drte = r(1);
    verts = r(1);
    r = r(2:length(r));
    
    while gche>=0 || drte>=0
        % find in vring a vertex to complete the triangle <i,gche,?>
        found = 0;
        if gche>0
            for x=r
                f = sort( [i,gche,x] );
                % search in face list
                for j=1:nface
                    if face(j,:)==f
                        gche = x;
                        found = 1;
                        verts = [x,verts];
                        xf = find(r~=x);    % pop vertex
                        r = r(xf);
                        break;
                    end
                end 
                if(found) break; end;
            end
            if(~found) gche=-1; end;
        end
        found = 0;
        if drte>0
            for x=r
                f = sort( [i,drte,x] );
                % search in face list
                for j=1:nface
                    if face(j,:)==f
                        drte = x;
                        found = 1;
                        verts = [verts,x];
                        xf = find(r~=x);    % pop vertex
                        r = r(xf);
                        break;
                    end
                end 
                if(found) break; end;
            end
            if(~found) 
                drte=-1; 
            end;
        end
    end

    if length(verts)~=length(vring{i})
        warning('Problem in 1-ring.');
    end
    
    % test for circularity or not
    f = sort( [i,verts(1),verts(end)] );
    found = 0;
    for j=1:nface
        if face(j,:)==f
            found = 1;
            break;
        end
    end 
    if(~found) 
        verts = [verts,-1]; 
    end;
    
    vring{i} = verts;
end
close(h);

