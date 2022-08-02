%Discrete Fourier transform.
%
%    Leutenegger Marcel © 6.8.2005
%
function o=fft(i,s,d)
if isa(i,'single')
   if nargin > 2
      if numel(d) ~= 1
         error('Invalid dimension.');
      end
      d=double(d);
   else
      d=[find(size(i) > 1) 2];
      d=d(1);
   end
   f=[];
   k=[];
   if nargin > 1
      s=double(s);
      if numel(s) == 1
         k=ones(1,max(d,ndims(i)));
         k(d)=s;
      end
   else
      s=[];
   end
   if d > ndims(i)
      if numel(k)
         o=repmat(i,k);
      else
         o=i;
      end
   else
      if numel(k) & s > size(i,d)
         f=fftwEstimate + fftwDestroyInput;
         i=subsasgn(i,struct('type','()','subs',{num2cell(k)}),0);
      end
      o=sfftw(i,f,-1,s,d);
   end
else
   if nargin > 2
      o=fft(i,double(s),double(d));
   else
      o=fft(i,double(s));
   end
end
