% FINARGPACK   各行を構成する NaN でない値のみを抽出して圧縮
% 
%   [Arr, NumPerRow] = finargpack(TrimFlag, A)
%   [Arr1, Arr2, ..., ArrM, NR1, NR2, ... NRM] = ...
%                      finargpack(TrimFlag, A1, A2, ... AM)
%
% 入力:
%   TrimFlag                - スカラフラグ。この値がゼロでない場合、NaN 
%                             の値をとる全ての列が、それぞれの引数から
%                             削除されます。
%   A, A1, ... AM           - 左側に圧縮される対象となる引数です。
%
% 出力:
%   Arr, Arr1, ... ArrM     - 出力配列。入力された行は、NaN を後に付加す
%                             ることによってパディングが行われますが、そ
%                             の入力された行から抽出された NaN 以外の値
%                             がこの配列に出力されます。
%   NumPerRow, NR1, ... NRM - 出力された配列の各行を構成する NaN 以外の
%                             入力値がいくつあるのか、その数をリスト表示
%                             している列です。
%
% 参考 : FINARGPAD, FINARGCAT.


%   Author(s): J. Akao
%   Copyright 1995-2002 The MathWorks, Inc. 
