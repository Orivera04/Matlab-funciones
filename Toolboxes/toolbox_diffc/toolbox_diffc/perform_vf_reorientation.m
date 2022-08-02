function w = perform_vf_reorientation(v, options)

% perform_vf_reorientation - try to reorient the vf.
%
%   w = perform_vf_reorientation(v, method);
%
%   'method' can be 'xproj', 'yproj', 'circproj' or 'localproj' or
%   'custproj' or 'randomized'.
%
%   'randomized' uses a slow simulated annealing method to optimize 
%   an Ising energy.
%
%
%   For 'custproj' you have to provide an additional vector w.
%
%   WORKS ONLY FOR 2D VECTOR FIELDS
%
%   Copyright (c) 2004 Gabriel Peyr?

options.null = 0;

if isfield(options, 'w')
    w = options.w;
else
    w = [1 0];
end
if isfield(options, 'method')
    method = options.method;
else
    method = 'xproj';
end

if size(v,3)~=2
    error('Works only for 2D vector fields.');
end

n = size(v,1);
p = size(v,2);



if strcmp(method, 'laplacian')
    
    % normalize 
    d = sqrt(sum(v.^2,3)); d(d<eps) = 1;
    v = v ./ repmat(d,[1 1 2]);
    % padd with zeros
    v0 = zeros(n+2,n+2,2);
    v0(2:end-1,2:end-1,:) = v; v = v0;    
    
    [dY,dX] = meshgrid(-1:1, -1:1); dX = dX(:); dY = dY(:);
    dX((end+1)/2) = []; dY((end+1)/2) = [];
    
    i = [n^2+1]; j = [n/2+(n/2-1)*n]; z = [1];
    u = zeros(n^2,1); % diagonal term
    for t=1:length(dX)
        dx = dX(t); dy = dY(t);
        % interaction
        a = sum( v(2:end-1,2:end-1,:) .* v(2+dx:end-1+dx,2+dy:end-1+dy,:), 3);
        
        [y,x] = meshgrid(1:n,1:n);
        I = find(x+dx>=1 & x+dx<=n & y+dy>=1 & y+dy<=n);
        x = x(I); y = y(I);        
        w = a( max(1-dx,1):min(end-dx,end), max(1-dy,1):min(end-dy,end) );
        w(abs(w)<1e-3) = 1e-3;
        i = [i; x+(y-1)*n ];
        j = [j; x+dx+(y+dy-1)*n ];
        z = [ z; w(:) ];
        % add to diagonal
        u(x+(y-1)*n) = u(x+(y-1)*n) + 1;
    end
    % add diagonal term
    [y,x] = meshgrid(1:n,1:n); x = x(:); y = y(:);
    i = [i; x+(y-1)*n ];
    j = [j; x+(y-1)*n ];
    z = [ z; -u(:) ];
    
    A = sparse(i,j,z);
    b = zeros(n^2+1, 1); b(end)=1;
    s = A\b;
    s = reshape(s,n,n);
    s = sign(s);
    
    w = v(2:end-1,2:end-1,:);
    w = w .* repmat(d, [1 1 2]) .* repmat(s, [1 1 2]);  
    return;
    
end

if strcmp(method, 'propagation')
    
    % normalize 
    d = sqrt(sum(v.^2,3)); d(d<eps) = 1;
    v = v ./ repmat(d,[1 1 2]);
    % padd with zeros
    v0 = zeros(n+2,n+2,2);
    v0(2:end-1,2:end-1,:) = v; v = v0;
    
    neigh = {[1 0] [-1 0] [0 1] [0 -1]};
    % state
    n1 = n+2;
    S = zeros(n1);
    S(1,:) = -1; S(:,1) = -1; S(end,:) = -1; S(:,end) = -1;
    % initial point
    list = floor(rand(2,1)*n)+2;
    Prio = zeros(n1,n1)+Inf; Prio(list(1),list(2))=0;
    iter = 0;
    while not(isempty(list))
        iter = iter+1;
        progressbar(iter,n^2);
        I = list(1,:) + (list(2,:)-1)*n1;
        prio = Prio(I);
        % extract best match
        [tmp,I] = max(prio);
        i = list(1,I); j = list(2,I);
        prio(I) = []; list(:,I) = [];
        % set to dead
        S(i,j) = -1;
        % compute average vector
        tau = [S(i+1,j); S(i-1,j); S(i,j+1); S(i,j-1)]; tau = tau==-1;
        mtau = sum(tau);
        if mtau==0 && iter>1
            error('Problem with computations.');
        end
        if mtau>0
            tau = repmat(tau, [1 1 2]);
            av = v(i+1,j,:).*tau(1,1,:) + v(i-1,j,:).*tau(2,1,:) + v(i,j+1,:).*tau(3,1,:) + v(i,j-1,:).*tau(4,1,:);
            av = av / mtau;
            if sum(av.*v(i,j,:))<0
                v(i,j,:) = -v(i,j,:);
            end
        end
        for s=1:length(neigh)
            is = i+neigh{s}(1); js = j+neigh{s}(2);
            if S(is,js)>=0 % update
                tau = [S(is+1,js); S(is-1,js); S(is,js+1); S(is,js-1)];  tau = tau==-1;
                mtau = sum(tau);
                if mtau==0
                    error('Problem with computations.');
                end
                tau = repmat(tau, [1 1 2]);
                av = v(is+1,js,:).*tau(1,1,:) + v(is-1,js,:).*tau(2,1,:) + v(is,js+1,:).*tau(3,1,:) + v(is,js-1,:).*tau(4,1,:);
                av = av / mtau;
                Prio(is,js) = abs( sum(av.*v(is,js,:)) );
                if S(is,js)==0
                    % add to the front
                    list(:,end+1) = [is;js];
                    S(is,js) = 1; % the front
                end
            end
        end
    end
    progressbar(iter,iter);
    
    w = v(2:end-1,2:end-1,:);
    w = w .* repmat(d, [1 1 2]);  
    return;
end

if strcmp(method, 'localproj')
    % special case.
    for i=1:n
        for j=1:n
            m = zeros(1,1,2);
            if i>1
                m = m + v(i-1,j,:);
            end
            if j>1
                m = m + v(i,j-1,:);
            end
            if i>1 && j>1
                m = m + v(i-1,j-1,:);
            end
            s = dot( m, v(i,j,:) );
            if s<0
                v(i,j,:) = -v(i,j,:);
            end
                
        end
    end    
      
    w = v;
    return;
end

if strcmp(method, 'randomized')

    % normalize 
    d = sqrt(sum(v.^2,3)); d(d<eps) = 1;
    v = v ./ repmat(d,[1 1 2]);
    
    % padd with zeros
    v0 = zeros(n+2,n+2,2);
    v0(2:end-1,2:end-1,:) = v; v = v0;
    vx = v(:,:,1);
    vy = v(:,:,2);
    
    % number of iterations
    if isfield(options, 'niter_reorient')
        niter = options.niter_reorient;
    else
        niter = 2000;
    end
    % make 2 sub-grids
    [Y,X] = meshgrid(1:n,1:n);
    I = find( mod(X(:)+Y(:),2)==0 );
    [i1,j1] = ind2sub([n n], I);
    I = find( mod(X(:)+Y(:),2)==1 );
    [i2,j2] = ind2sub([n n], I);
    
    delta1 = 0.9; delta2 = 0;
    tlist = linspace(0,1,niter);
%    tlist = tlist.^3;
    
    err = [];
    for k=1:niter
        progressbar(k,niter);
        if mod(k,2)==1
            i = i1+1; j=j1+1;
        else
            i = i2+1; j=j2+1;
        end 

        wx = vx( i + (j-1)*(n+2) );
        wy = vy( i + (j-1)*(n+2) );

        zx =    vx( i+1 + (j-1)*(n+2) ) + ...
            vx( i   + (j  )*(n+2) ) + ...
            vx( i-1 + (j-1)*(n+2) ) + ...
            vx( i   + (j-2)*(n+2) );
        zy =    vy( i+1 + (j-1)*(n+2) ) + ...
            vy( i   + (j  )*(n+2) ) + ...
            vy( i-1 + (j-1)*(n+2) ) + ...
            vy( i   + (j-2)*(n+2) );
        % normalize
        dd = sqrt(zx.^2+zy.^2); dd(dd<eps) = 1;
        zx = zx./dd; zy = zy./dd;
        
        delta = (1-tlist(k))*delta1 + tlist(k)*delta2;
        
        s = wx.*zx + wy.*zy;
        s = sign(s-delta);
        vx( i + (j-1)*(n+2) ) = wx.*s;
        vy( i + (j-1)*(n+2) ) = wy.*s;
        err(end+1) = sum(s<0);
    end
    v = cat(3,vx,vy);
    w = v(2:end-1,2:end-1,:);
    w = w .* repmat(d, [1 1 2]);
    return;
end

switch lower(method)
    case 'xproj'    
        s = v(:,:,1);
    case 'yproj'
        s = v(:,:,2);
    case 'circproj'
        n = size(v,1);
        p = size(v,2);
        [Y,X] = meshgrid(0:p-1, 0:n-1);
        s = v(:,:,1).*X + v(:,:,2).*Y;
    case 'custproj'
        s = v(:,:,1)*w(1) + v(:,:,2)*w(2);
    otherwise
        error('Unknown method');
end


s = sign(s);
I = find(s==0); s(I) = 1;
w = v;
w(:,:,1) = v(:,:,1).*s;
w(:,:,2) = v(:,:,2).*s;
    
    