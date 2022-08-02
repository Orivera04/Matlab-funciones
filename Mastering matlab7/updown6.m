% updown6.m
% up-down algorithm

if ~exist('Nums','var')     % numbers to test
   Nums = 25:50;
end
N = uint32(Nums);                 % duplicate numbers as uint32
Counts = zeros(size(N),'uint32'); % preallocate array as uint32

not1 = N>1;                       % True for numbers greater than one

while any(not1)
   
   odd = 2*(N/2)~=N;              % True for odd values
   
   odd_not1 = odd & not1;         % True for odd values greater than one
   even_not1 = ~odd & not1;       % True for even values greater than one
   
   N(even_not1) = N(even_not1)/2;           % Process evens
   Counts(even_not1) = Counts(even_not1)+1;
   
   N(odd_not1) = (3*N(odd_not1)+1)/2;       % Process odds
   Counts(odd_not1) = Counts(odd_not1)+2;
   
   not1=N>1;                   % Find remaining numbers
end
%results=[Nums' Counts']