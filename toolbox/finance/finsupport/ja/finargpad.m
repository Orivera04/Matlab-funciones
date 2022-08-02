% FINARGPAD   配列を共通のサイズにパディング
%
%   [Arr1, Arr2, ..., ArrM] = finargpad('all', A1, A2, ... AM)
%   [Arr1, Arr2, ..., ArrM] = finargpad(PadDims, A1, A2, ... AM)
%
% 入力:
%   PadDims             - 適合するサイズにパディングすべき次元をリストで
%                         入力します。なお、全ての次元がパディングの対象
%                         となる場合は、文字列 'all' を入力します。
%   A, A1, ... AM       - パディング対象となる引数です。
%
% 出力:
%   Arr, Arr1, ... ArrM - 出力される配列です。出力される配列は、PadDims 
%                         にリストアップされた各次元上で同一のサイズをと
%                         ります。また、パディングには NaN が用いられま
%                         す。
%
% 参考 : FINARGPACK, FINARGCAT, FINARGSZ.


%   Author(s): J. Akao
%   Copyright 1995-2002 The MathWorks, Inc. 
