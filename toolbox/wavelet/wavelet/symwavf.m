function F = symwavf(wname)
%SYMWAVF Symlet wavelet filter.
%   F = SYMWAVF(W)  returns the scaling filter
%   associated with the symlet wavelet specified
%   by the string W, where W = 'symN'.
%   Possible values for N are:
%      N = 2, 3, 4 ... 45.
%
%   See also SYMAUX, WAVEINFO.

%   M. Misiti, Y. Misiti, G. Oppenheim, J.M. Poggi 12-Mar-96.
%   Last Revision: 22-May-2003.
%   Copyright 1995-2004 The MathWorks, Inc.
% $Revision: 1.11.4.2 $

% Check arguments.
if nargin==0
    F = 45; 
   % F contains the number max for Daubechies wavelet.
    return
end

lw = length(wname); ab = abs(wname);
ii = lw+1; 
while (ii>1) && (47<ab(ii-1)) && (ab(ii-1)<58) , ii = ii-1; end
num = wstr2num(wname(ii:lw));

switch num
  case 1
  F = [...
   0.50000000000000   0.50000000000000  ...
                ];
  case 2
  F = [...
   0.34150635094622   0.59150635094587   0.15849364905378  -0.09150635094587  ...
                ];

  case 3
  F = [...
   0.23523360389270   0.57055845791731   0.32518250026371  -0.09546720778426  ...
  -0.06041610415535   0.02490874986589                                        ...
                ];

  case 4
  F = [...
   0.02278517294800  -0.00891235072085  -0.07015881208950   0.21061726710200  ...
   0.56832912170500   0.35186953432800  -0.02095548256255  -0.05357445070900  ...
                ];

  case 5
  F = [...
   0.01381607647893  -0.01492124993438  -0.12397568130675   0.01173946156807  ...
   0.44829082419092   0.51152648344605   0.14099534842729  -0.02767209305836  ...
   0.02087343221079   0.01932739797744                                        ...
                ];

  case 6
  F = [...
  -0.00551593375469   0.00124996104639   0.03162528132994  -0.01489187564922  ...
  -0.05136248493090   0.23895218566605   0.55694639196396   0.34722898647835  ...
  -0.03416156079324  -0.08343160770584   0.00246830618592   0.01089235016328  ...
                ];

  case 7
  F = [...
   0.00726069738101   0.00283567134288  -0.07623193594814  -0.09902835340368  ...
   0.20409196986287   0.54289135490599   0.37908130098269   0.01233282974432  ...
  -0.03503914561106   0.04800738396784   0.02157772629104  -0.00893521582557  ...
  -0.00074061295730   0.00189632926710                                        ...
                ];

  case 8
  F = [...
   0.00133639669640  -0.00021419715012  -0.01057284326418   0.00269319437688  ...
   0.03474523295559  -0.01924676063167  -0.03673125438038   0.25769933518654  ...
   0.54955331526901   0.34037267359439  -0.04332680770282  -0.10132432764282  ...
   0.00537930587524   0.02241181152181  -0.00038334544811  -0.00239172925575  ...
                ];

  otherwise
    if (9<=num) && (num<=45)
       F = symaux(num);
    else
      errargt(mfilename,'Invalid Symlets wavelet number !','msg');
      error('*');
   end
end