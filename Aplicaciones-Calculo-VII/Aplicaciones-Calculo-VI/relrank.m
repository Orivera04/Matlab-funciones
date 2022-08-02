function x=relrank(A)
% take vector of permeated integers and find relative ranks if sequentially revealed
% useful for simulating sequential search problems like the secretary problem
% by Ryan O. Murphy
% rom2102@columbia.edu
% January, 24th  2006

[f,g]=size(A);
if f*g==length(A);
    if g==1
        A=A';
    end
    output=[];
    for round = 1:length(A);
        godsranking=(A(1:round));
        [y,i]=sort(godsranking);
        [a,localranking]=sort(i);
        output=[output; [localranking,zeros(1,length(A)-round)]];
    end
    x=diag(output)';
elseif f*g~=length(A);
    disp('Input error');
end
