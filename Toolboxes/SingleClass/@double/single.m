%Convert to single precision.
%
%    Leutenegger Marcel © 26.4.2005
%
%  This class provides floating point computation in
%  the single precision floating point format of the
%  processor. A single value has 24 significant bits
%  (mantissa) instead of 53 bits in double.
%
%  The class provides higher performance at the cost
%  of less accuracy. Also, single data occupies only
%  half the memory of double data.
%
%  Access to constants is provided by
%
%     eps(single)       == pow2(-23)
%     pi(single)        == single(pi)
%     ones(single)
%     rand(single)
%     randn(single)
%     realmax(single)
%     realmin(single)
%     zeros(single)
%