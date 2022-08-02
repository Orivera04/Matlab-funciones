function str=getUnd2BStr(in)
%this is used for display 
[mR mC]=size(in);
str=in;
for k = 1:mR
  count=0;
   while(count~=length(str(k, :)))
       if(str(k, (count+1))=='_') %erasing as many '_' as their are for a particular entry         
           str(k, (count+1))=' ';       
      end
     count=count+1;
   end
end
