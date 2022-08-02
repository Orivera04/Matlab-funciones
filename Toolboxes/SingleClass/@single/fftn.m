%N-dimensional discrete Fourier transform.
%
%    Leutenegger Marcel © 6.8.2005
%
function o=fftn(i,s)
if isa(i,'single')
   if nargin > 1
      f=[];
      s=double(s);
      if numel(s) < ndims(i)
         error('Incompatible dimensions.');
      end
      if any(s(:) < 1)
         o=single(zeros(s));
         return;
      end
      d=[size(i) ones(1,numel(s)-ndims(i))];
      if any(d < s)
         f=fftwEstimate + fftwDestroyInput;
         i=subsasgn(i,struct('type','()','subs',{num2cell(s)}),0);
      end
      o=sfftw(i,f,-1,double(s));
   else
      o=sfftw(i);
   end
else
   o=fftn(i,double(s));
end
