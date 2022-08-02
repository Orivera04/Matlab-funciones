function P = pointonsphere(N)
%
% P = pointonsphere(N)
% Put N uniformly distributed points on unit sphere
% Input: Scalar (integer) N
% Output: Nx3 matrix P for point positions
%                           by Leevan Ling, U.Tokyo
% ver01, Dec.17/2004
%

if N == 1,
    P = [0 0 1];
    return
end
if N==2
    P = [ 0 0 1; 0 0 -1];
    return
end
% Good for large N, say N=100.
del = sqrt(0.2e1) * sqrt(((6 * N) + 0.3e1 *...
    pi - 0.12e2 - sqrt(0.3e1) * sqrt(((6 * N)...
    + pi - 0.12e2) * ((2 * N) - pi - 0.4e1)))...
    / (pi - 0.8e1 + (4 * N)));
try % if you have optimization toolbox
    F=@(x) pi*(cos(x)+1)+(2-N)*x*sin(x);
    del = fsolve( F, del, optimset('Display','off'));
end
Nc=round(pi/del)-1;
dd=2*pi*sum(sin([1:Nc]*del))/(N-2);
P = [ 0 0 1; 0 0 -1];
if Nc ==1,
    theta = angle(N - 2);
    P = [P; cos(theta), sin(theta), zeros(size(theta))];
elseif mod(Nc,2)==1
    for i=1:((Nc-1)/2),
        ri = sin( i * pi/(Nc+2) );
        ni = round(2*pi*ri/dd);
        theta = angle(ni);
        if mod(i,2)==1,
            theta = shift(theta);
        end
        phi = i*pi/(Nc+1);
        P = [P; cos(theta).*sin(phi), ...
            sin(theta).*sin(phi), ...
            ones(size(theta)).*cos(phi); ...
            cos(theta).*sin(phi), ...
            sin(theta).*sin(phi), ...
            -ones(size(theta)).*cos(phi)];
    end
    ni =  N - length(P);
    theta = angle(ni);
    P = [P; cos(theta), sin(theta), zeros(size(theta))];
else
    for i=1:(Nc/2-1),
        ri = sin( i * pi/(Nc+2) );
        ni = round(2*pi*ri/dd);
        theta = angle(ni);
        if mod(i,2)==1,
            theta = shift(theta);
        end
        phi = i*pi/(Nc+1);
        P = [P; cos(theta).*sin(phi), ...
            sin(theta).*sin(phi), ...
            ones(size(theta)).*cos(phi); ...
            cos(shift(theta)).*sin(phi), ...
            sin(shift(theta)).*sin(phi), ...
            -ones(size(theta)).*cos(phi)];
    end
    ni =  N - length(P);
    n1 = round(ni/2);
    n2 = ni-n1;
    phi = (Nc/2)*pi/(Nc+1);
    theta1 = angle(n1);
    theta2 = angle(n2);
    if mod(Nc/2,2)==1,
        theta1 = shift(theta1);
        theta2 = shift(theta2);
    end
    P = [P; cos(theta1).*sin(phi), ...
        sin(theta1).*sin(phi), ...
        ones(size(theta1)).*cos(phi); ...
        cos(shift(theta2)).*sin(phi), ...
        sin(shift(theta2)).*sin(phi), ...
        -ones(size(theta2)).*cos(phi)];
end
if nargout==0,
    figure
    plot3( P(:,1), P(:,2), P(:,3), '.');
    xlabel('x'),ylabel('y'),zlabel('z')
    axis square
end
function t=angle(n)
t = linspace(0, 2*pi, n+1)';
t = t(1:n);
function t1=shift(t0)
dt = t0(2) - t0(1);
t1 = t0 + dt/2;
