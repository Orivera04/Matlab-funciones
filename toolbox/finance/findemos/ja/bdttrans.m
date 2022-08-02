% BDTTRANS   BDTBOND によって出力されたツリーの変換
%
% 短期割引ツリーを短期レートツリーへ変換するか、もしくは価格ツリー構造を
% クリーン価格ツリーに変換します。出力は、ツリーノードの値で構成される
% 行列とノードタイムのベクトルとなります。
%
% 使用法：
%   [TreeMat, TreeTimes] = bdttrans(Tree)
%   bdttrans(Tree)
% 
% 入力:
%   Tree : BDTBOND によって出力されたツリー構造
%
% 出力：
%   TreeMat : [NSTATES行NTIMES列] ツリー上の各点が短期レート、または
%             クリーン価格の値の変換後の行列です。時間層は、様々な状態を
%             含む列で示されています。行列の未使用の入力は、NaN値でマスク
%             されます。
%
%   TreeTimes: [1行NTIMES列] TreeMat の各層 に対応する時間ベクトルです。
% 
% BDTTRANS が、出力引数なしで呼び出された場合、クーポン期間の時間軸に
% 対して、変換されたツリーをプロットします。
%
% 参考 : BDTBOND, PLOTBINTREE.


%   Author: J. Akao, 05-18-98
%   Copyright 1995-2002 The MathWorks, Inc.  
