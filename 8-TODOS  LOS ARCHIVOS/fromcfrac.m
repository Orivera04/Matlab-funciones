
% Return the number whose continued fraction coefficieints are given as a row or column vector.
% This vector may be taken as the first column vector of the output of
% cfrac, roundcfrac, QCF, or RoundQCF.

function fcf = fromcfrac( a )

len = length( a );
p2 = 0;
q2 = 1;
p1 = 1;
q1 = 0;
p = a(1);
q = 1;

for i=2:len
    p2 = p1;
    q2 = q1;
    p1 = p;
    q1 = q;
    p = p1 * a(i) + p2;
    q = q1 * a(i) + q2;
end

fcf = p/q;