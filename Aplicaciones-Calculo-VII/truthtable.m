function truth_table = truthtable(nb_possibles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculates the binary truth table of n possibilities. 
%
% Written by Torsten Geiss (c)2006.  torstengeiss@gmail.com 
% 
% usage:    b=truthtable(n)
%
% example:  n = 8
% 
% truth_table = truthtable(8)
%
% truth_table =
% 
%           1     1     1
%           1     1     0
%           1     0     1
%           1     0     0
%           0     1     1
%           0     1     0
%           0     0     1
%           0     0     0
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

truth_table = [];
for k = 0:(nb_possibles -1)
    x = dec2binvec(k,log2(nb_possibles));
    truth_table = [truth_table; x];
end
truth_table = flipud(truth_table);

function out = dec2binvec(dec,n)
%DEC2BINVEC Convert decimal number to a binary vector.
% modified from MATLAB DAQ TOOLBOX.  MSB is in first position now.

% Convert the decimal number to a binary string.

   out = dec2bin(dec,n);
   % Convert the binary string, '1011', to a binvec, [1 1 0 1].
   pre = logical(str2num([fliplr(out);blanks(length(out))]')'); 
   out = pre(end:-1:1);
