% INSTLENGTH   商品変数内に保持されている商品の数をカウント
%
%    NInst = instlength(InstSet)
%
% 入力: 
%   InstSet - 商品の集合からなる変数。商品は、タイプ毎に分類され、そのそ
%             れぞれのタイプについて互いに異なるデータフィールドを設定す
%             ることができます。記憶されたデータフィールドは、商品のそれ
%             ぞれに対応する行ベクトル、または、文字列となっています。
%
% 出力:
%   NInst   - 変数 InstSet に含まれる商品の数
%
% 例題:  
% InstSet 変数、ExampleInst をデータファイルから取得します。この変数に
% は、7つの商品が含まれています。
%
%   load InstSetExamples.mat
%   instdisp(ExampleInst)
%
%   NInst = instlength(ExampleInst)
%   NInst = 
%        7
%
% 参考 : INSTTYPES, INSTFIELDS, INSTDISP.


%   Copyright 1995-2002 The MathWorks, Inc. 
