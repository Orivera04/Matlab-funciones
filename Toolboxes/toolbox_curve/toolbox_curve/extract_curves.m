function c_list = extract_curves(M, t, options)

% extract_curves - extract level set curves from an image.
%
%   c_list = extract_curves(M, t, nb);
%
%   'M' is the image.
%   't' is the level.
%   'nb' is the number of curves extracted (only the 'nb' longest).
%   'c_lit' is a cell array of 2D curves.%
%
%   Copyright (c) 2004 Gabriel Peyré

if nargin<2
    t = 0;
end
if nargin<3
    options.null = 0;
end

n = size(M,1);
x = 0:1/(n-1):1;
c = contourc(x,x,M',[t,t]);
clear c_list;
k = 0;
p = 1;
while p < size(c, 2)
    lc = c(2,p);   % length of the curve
    cc = c(:,(p+1):(p+lc));
    p = p+lc+1;
    k = k+1;
    c_list{ k } = cc;
end

n = length(c_list);

% filter by nb
if isfield(options, 'max_nb')
    max_nb = options.max_nb;
    l = zeros(n,1);
    for i=1:n
        l(i) = length(c_list{i});
    end
    [tmp,I] = sort(l);
    I = reverse( I );
    I = I( 1:(min(max_nb,n)) );
    c_list1 = c_list;
    clear c_list;
    for i = 1:length(I)
        c_list{i} = c_list1{I(i)};
    end        
end

% filter by size
if isfield(options, 'min_length')
    min_length = options.min_length;
    c_list1 = c_list;
    clear c_list;
    k = 0;
    for i=1:n
        l = length(c_list1{i});
        if l>=min_length
            k = k+1;
            c_list{k} = c_list1{i};
        end
    end
end