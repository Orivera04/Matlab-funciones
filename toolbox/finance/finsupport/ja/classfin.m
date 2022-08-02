% CLASSFIN   ���Z�I�u�W�F�N�g�̐����A�܂��́A���Z�N���X���̏o��
% 
% �g�p�@1: ClassName�N���X�̋��Z�\���̂��o�͂��܂��B
%    Obj = classfin(ClassName)
%    Obj = classfin(Struct, ClassName)
%
% ����:
%    Struct    - ���Z�\���̂ɕϊ������\���̂ł��B
%    ClassName - ���Z�\���̃N���X�̖��O����Ȃ镶����ł��B
%
% �o��:
%    Obj       - ���Z�\���̗̂�ł��B
%
%
% �g�p�@ 2: ���Z�\���̂̃N���X�����o�͂��܂��B
%    ClassName = classfin(Obj)
% 
% ����:
%    Obj       : ���Z�\���̗�ł��B
%
% �o��:
%    ClassName : ���Z�\���̂̃N���X������Ȃ镶����ł��B
%
% ���:
%   1)  HJMTimeSpec���Z�\���̂̋�̗�𐶐����A���������\���̂̃t�B�[��
%       �h�����������܂�(�ʏ�́A�֐�hjmtimespec���AHJMTimeSpec�\���̂�
%       �����ɂ͗p�����܂�)�B
%
%     TimeSpec = classfin('HJMTimeSpec');
%     TimeSpec.ValuationDate = datenum('Dec-10-1999');
%     TimeSpec.Maturity = datenum('Dec-10-2001');
%     TimeSpec.Compounding = 2;
%     TimeSpec.Basis = 0;
%     TimeSpec.EndMonthRule = 1;
%
%   2)�����̍\���̂�����Z�\���̂𐶐����܂��B
%
%     TSpec.ValuationDate = datenum('Dec-10-1999');
%     TSpec.Maturity = datenum('Dec-10-2001');
%     TSpec.Compounding = 2;
%     TSpec.Basis = 0;
%     TSpec.EndMonthRule = 0;
%     TimeSpec = classfin(TSpec, 'HJMTimeSpec');
%
%   3)���Z�\���̂̃N���X�����擾���܂��B
%     load HJMExamples
%     ClassName = classfin(ExHJMTree)
%
%
% �Q�l : ISAFIN.


%   Author(s): J. Akao 12/17/98
%   Copyright 1995-2002 The MathWorks, Inc. 
