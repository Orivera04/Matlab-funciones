% % if vin is row vector change it to column vector then return it.
% % if vin is column vector then return it as it is.
% % if vin is not a vector diplay error message is displaye
% % example column vector: vout=[5;
% %                              8;
% %                              6];


function vout=getcolvector(vin)

if(~isvec(vin)  )
    error('input must be a vector');    
end

vout=vin;
[r c]=size(vin);
if (r==1)      % vin is row vector, make it col. vector 
    vout=vin';
end

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


