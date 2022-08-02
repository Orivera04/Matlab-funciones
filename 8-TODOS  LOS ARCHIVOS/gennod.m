function nod = gennod(ne,nx,ny)
l = -1;
jj = -1;
nym = ny-1;
nxm = nx-1;
k = nxm;
for i = 1:nym
    k = k+1;
    l = l+1;
    for j = 1:nxm
        k = k+1;
        l = l+1;
        jj = jj+2;
        nod(jj,1) = k;      % = l;
        nod(jj,2) = l;      % = l+1;
        nod(jj,3) = k+1;    % = k;
        jjp = jj+1;
        nod(jjp,1) = l+1;   % = k+1;
        nod(jjp,2) = k+1;   % = k;
        nod(jjp,3) = l;     % = l+1;
    end
end