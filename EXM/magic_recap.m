%% Magic Squares Chapter Recap 
% This is an executable program that illustrates the statements
% introduced in the Magic Squares Chapter of "Experiments in MATLAB".
% You can access it with
%
%    magic_recap
%    edit magic_recap
%    publish magic_recap
%
% Related EXM programs
%
%    magic
%    ismagical

%% A Few Elementary Array Operations.
    format short
    A = magic(3)
    sum(A)
    sum(A')'
    sum(diag(A))
    sum(diag(flipud(A)))
    sum(1:9)/3
    for k = 0:3
       rot90(A,k)
       rot90(A',k)
    end

%% Durer's Melancolia
    clear all
    close all
    figure
    load durer
    whos
    image(X)
    colormap(map)
    axis image

%% Durer's Magic Square
    figure
    load detail
    image(X)
    colormap(map)
    axis image
    A = magic(4)
    A = A(:,[1 3 2 4])

%% Magic Sum
    n = (3:10)';
    (n.^3 + n)/2

%% Odd Order
    n = 5
    [I,J] = ndgrid(1:n);
    A = mod(I+J+(n-3)/2,n);
    B = mod(I+2*J-2,n);
    M = n*A + B + 1

%% Doubly Even Order
    n = 4
    M = reshape(1:n^2,n,n)';
    [I,J] = ndgrid(1:n);
    K = fix(mod(I,4)/2) == fix(mod(J,4)/2);
    M(K) = n^2+1 - M(K)

%% Rank
    figure
    for n = 3:20
       r(n) = rank(magic(n));
    end 
    bar(r)
    axis([2 21 0 20])

%% Ismagical
    help ismagical
    for n = 3:10
       ismagical(magic(n))
    end

%% Surf Plots
    figure
    for n = 9:12
       subplot(2,2,n-8)
       surf(rot90(magic(n)))
       axis tight off
       text(0,0,20,num2str(n))
    end
    set(gcf,'color','white')
