function k = mymenu(s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14)

%function k = mymenu(s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14)
%
%Produces a menu in the input window rather than a separate window of its own.
%
%                                        A. Knight, Sept. 1992

disp(' ')
disp(['----- ',s0,' -----'])
disp(' ')
for i=1:(nargin-1)
    disp(['      ',int2str(i),') ',eval(['s',int2str(i)])])
end
disp(' ')
k = input('Select a menu number: ');
return
