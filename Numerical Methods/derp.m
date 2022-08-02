
function dp = derp(p)

% Derivative dp of an algebraic polynomial that is 
% represented by its coefficients p. They must be stored 
% in the descending order of powers.

n = length(p) - 1;
p = p(:)';                % Make sure p is a row array.
dp = p(1:n).*(n:-1:1);    % Apply the Power Rule.
k = find(dp ~= 0);
if ~isempty(k)            
   dp = dp(k(1):end);     % Delete leading zeros if any.
else
   dp = 0;
end
