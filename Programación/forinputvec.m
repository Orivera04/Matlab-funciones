function numvec = forinputvec(n)
% forinputvec returns a vector of lenght n
% It Prompts the user and puts n numbers into a vector
% Format: forinputvec(n)

numvec = zeros(1,n);
for iv = 1:n
    inputnum = input('Enter a number: ');
    numvec(iv) = inputnum;
end
end
