%Two-dimensional discrete Fourier transform.
%
%    Leutenegger Marcel © 6.8.2005
%
function o=fft2(i,m,n)
if isa(i,'single')
   f=[];
   if nargin > 1
      if nargin > 2
         m=[double(m) double(n)];
      else
         m=double(m);
      end
      if numel(m) ~= 2
         error('Incompatible dimensions.');
      end
      s=size(i);
      s(1:2)=m;
      if any(s < 1)
         o=single(zeros(s));
         return;
      end
      if any([size(i,1) size(i,2)] < m)
         f=fftwEstimate + fftwDestroyInput;
         i=subsasgn(i,struct('type','()','subs',{num2cell(s)}),0);
      end
      o=sfftw(i,f,-1,m,[1 2]);
   else
      o=sfftw(i,f,-1,f,[1 2]);
   end
else
   if nargin > 2
      o=fft2(i,double(m),double(n));
   else
      o=fft2(i,double(m));
   end
end
