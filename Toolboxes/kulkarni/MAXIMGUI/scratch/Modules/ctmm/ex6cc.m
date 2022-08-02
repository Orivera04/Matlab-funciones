function R = ex6cc(l,m,M,H);

% Computes the Rate matrix for the Call Center of Example 6.11.
% Usage: l: call arrival rate in hours;
%        m: number of calls served by one server per hour.
%        M: Number of reservation clerks;
%        H: Number of calls that can be put on hold;

R = zeros(M+H+1,M+H+1) ;

for i = 0:M+H-1
  R(i+1,i+2) = l ;
end

for i = 1:M
  R(i+1,i) = i*m ;
end

for i = M+1:M+H
  R(i+1,i) = M*m ;
end

