% return 1 if input argument is vecotor else return 0

function ans=isvec(x)
ans=0;
d=size(x);

if(length(d)>2) % not vector
    return 
end

[r c]=size(x);

if (r>1 & c>1) % not vector
    return
end

ans=1; % vector


    

% % % -------------------------------------------------------------------------
% % % This program or any other program(s) supplied with it does not provide any
% % % warranty direct or implied. This program is free to use/share for
% % % non-commercial purpose only, for any other usage contact with author.
% % % Kindly reference author.
% % % Thanking you.
% % % @ Copyright M Khan
% % % Email: mak2000sw@yahoo.com
% % %        mak2000@GameBox.net 
% % % http://www.geocities.com/mak2000sw