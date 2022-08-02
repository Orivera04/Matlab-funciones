% INSTTYPES   商品変数内に記憶されているタイプのリストを抽出
%
%   [TypeList] = insttypes(InstSet)
%
% 入力: 
%   InstSet  - 商品の集合からなる変数。商品は、タイプ毎に分類され、その
%              それぞれのタイプについて互いに異なるデータフィールドを
%              設定することができます。記憶されたデータフィールドは、
%              商品のそれぞれに対応する行ベクトル、または、文字列となって
%              います。
%
% 出力:
%   TypeList - 商品変数内に含まれる商品のタイプをリスト表示する文字列か
%              らなる NTYPE 行1列のセル配列。
%
% 例題:
% InstSet 変数、ExampleInst をデータファイルから取得します。
% この変数の中には、つぎの3つのタイプの商品が含まれています。
% 'Option', 'Futures', 'TBill'.
%
%   load InstSetExamples.mat
%   instdisp(ExampleInst)
%
%   TypeList = insttypes(ExampleInst)
%   TypeList = 
%       'Futures'
%       'Option'
%       'TBill'
%
% 参考 : INSTFIELDS, INSTLENGTH, INSTDISP.


%   Copyright 1995-2002 The MathWorks, Inc. 
