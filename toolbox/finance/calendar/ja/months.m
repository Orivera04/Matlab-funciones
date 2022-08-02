% MONTHS   日付間の全ての月の数
%
% MM = MONTHS(D1,D2,EOM) は、2つの日付 D1 及び D2 間の全ての月の数を出力
% します。EOM は、月の末日に相当する日付をさらなる1つの完全な月として
% 扱うか(EOM = 1, デフォルト)、その他の場合(EOM = 0)を決定します。
%         
% たとえば、mm = months('31-march-1997','30-Jun-1997',1) は、mm = 3 を
% 出力し、mm = months('31-march-1997','30-Jun-1997',0) は、mm = 2 を
% 出力します。
% 
% 参考 : YEARFRAC.


%   Author(s): C.F. Garvin, 1-09-96
%   Copyright 1995-2002 The MathWorks, Inc. 
