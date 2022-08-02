% PORTRAND   ランダムなポートフォリオのリスク、収益、加重値を出力
%
% [RISK,ROR,WEIGHTS]=PORTRAND(ASSET,RET,PTS) は、ランダムなポートフォリオ
% 構成のリスク、収益、加重値のベクトルを出力します。ASSET は、M 行 N 列
% の行列で、各列が1つの有価証券の時系列データを表します。RET は1行 N 列
% のベクトルで、各列がASSET 内の対応する有価証券の収益率を表します。PTS 
% はベクトルでどれだけ多くのランダムポイントを生成するかを指定するスカラ
% 値です。 RISK は PTS 行1列の標準偏差ベクトル、ROR は PTS 行1列の期待収
% 益率ベクトル、WEIGHTS は PTS 行 N 列の資産加重値行列です。加重値 
% WEIGHTS の各行は、それぞれ異なるポートフォリオ構成となっています。
% デフォルトでは、PTS = 1000で、 RET は ASSET の各列の平均値をとって計算
% します。
% 
% PORTRAND(ASSET,RET,PTS) は、各ポートフォリオ構成を表す点をプロットし
% ます。
%       
% この関数は、MATLAB Financial Expo において使用され、同じポートフォリオ
% の複数の加重組み合わせがどのようにして同じ期待収益率を実現するかを説明
% するものです。
%
% ランダムな加重組み合わせを生成してください。
%
% 参考 : FRONTIER, PORTVAR, PORTROR .
%
% 参考文献: Bodie, Kane, and Marcus, Investments, Chapter 7.


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
