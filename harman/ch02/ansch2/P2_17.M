% P2_17.M Convert an octal fraction to decimal by callin 
%  function foct2dec. Input octal fraction as vector [o o o ..]
fracoct=input('Input octal fraction as a vector ')
format long	% Show full precision
fprintf('Decimal Value\n')
dec = foct2dec(fracoct)
format short