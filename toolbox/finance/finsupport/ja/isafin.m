% ISAFIN   引数が金融構造タイプ、または、金融オブジェクトクラスの場合、
%          真を出力
% 
%   IsFinObj = isafin(Obj, ClassName)
%
%  入力:
%    Obj       - 金融構造体の具体例
%
%    ClassName - 金融構造クラスの名称からなる文字列
%
%  出力：
%    IsFinObj  - 入力引数が金融構造タイプの場合、または、金融オブジェク
%                トクラスの場合に真を出力、そうでなければ偽を出力します。
%
%  例題:
%     load deriv
%     IsFinObj = isafin(HJMTree, 'HJMFwdTree')
%     は、True を出力します。
%
%  参考 : CLASSFIN.


%   Author(s): J. Akao 12/17/98
%   Copyright 1995-2002 The MathWorks, Inc. 
