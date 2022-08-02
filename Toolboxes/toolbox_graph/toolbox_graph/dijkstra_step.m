function data1 = dijkstra_step(data)

% dijkstra_step - perform one step in the dijkstra algorithm
%
%   [O1,C1] = dijkstra_step(O,C,W,adj_list);
%
%   Copyright (c) 2004 Gabriel Peyr�

A = data.A; % action 
O = data.O; % open list
C = data.C; % close list
S = data.S; % state, either 'O' or 'C'
F = data.F; % Father
P = data.P; % Origin seed point
H = data.H; % Heuristic
adj_list = data.adj_list;   % adjacency list
W = data.W; % weight matrix
heuristic = data.heuristic;

if isempty(O)
    data1 = data;
    return;
end

[m,I] = min(A(O)+H(O));
x = O(I(1));   % selected vertex

% pop from open and add to close
O = O( find(O~=x) );
C = [C,x];
S(x) = 'C'; % now its close
% its neighbor
nei = adj_list{x}; 

for i=nei
    w = W(x,i);
    A1 = A(x) + w;    % new action from x
    switch S(i)
        case 'C'
            % check if action has change. Should not appen for dijkstra
            if A1<A(i)
                % pop from Close and add to Open  
                C = C( find(C~=i) );
                O = [O,i];
                S(i) = 'O';
                A(i) = A1;
                F(i) = x;       % new father in path
                P(i) = P(x);    % new origin
            end
        case 'O'
            % check if action has change.
            if A1<A(i)
                A(i) = A1;
                F(i) = x;   % new father in path
                P(i) = P(x);    % new origin
            end
        otherwise
            if A(i)~=Inf
                warning('Action must be initialized to Inf');  
            end    
            if heuristic.weight~=0
                % we use an heuristic
                str = sprintf( 'd = %s( i, heuristic );', heuristic.func );
                eval(str);
                H(i) = heuristic.weight*d;
            end
            % add to open
            O = [O,i];
            S(i) = 'O';
            % action must have change.
            A(i) = A1;
            F(i) = x;   % new father in path
            P(i) = P(x);    % new origin
    end
end

data1.A = A;
data1.O = O;
data1.C = C;
data1.S = S;
data1.P = P;
data1.adj_list = adj_list;
data1.W = W;
data1.F = F;
data1.heuristic = heuristic;
data1.H = H;