% M2XDATE   MATLAB�V���A�����t�ԍ���Excel�V���A�����t�ԍ��ɕϊ�
% 
% DateNumber = m2xdate(MATLABDateNumber, Convention)
%
% �ڍׁF ���̊֐��́AMATLAB�V���A�����t�ԍ�������Excel�V���A�����t�ԍ�
%        �����ɕϊ����܂��B
%
% ����: 
% MATLABDateNumber - MATLAB�V���A�����t�ԍ��ŕ\�����ꂽ�V���A�����t�ԍ�
%                    ��N�s1��A�܂��́A1�sN��̃x�N�g���ł��B
%  
% Convention       - MATLAB�V���A�����t�ԍ�����ϊ����s���ۂɁA�ǂ� 
%                    Excel�V���A�����t�ԍ��ϊ��K����p���邩������ 
%                    N�s1��A�܂��́A1�sN��̃x�N�g���A�܂��́A�X�J����
%                    �t���O�l�ł��B�ݒ�ł���l�́A���̒ʂ�ƂȂ�܂��B
%                    a) Convention = 0 - �V���A�����t�ԍ�1���A1899�N12��
%                                        31���ɑΉ�����1900���t�V�X�e��
%                                        (�f�t�H���g)
%                    b) Convention = 1 - �V���A�����t�ԍ�0���A1904�N1��1��
%                                        �ɑΉ�����1904���t�V�X�e��
%
% �o��: Excel�V���A�����t�ԍ��`���ŕ\�����ꂽ�V���A�����t�ԍ���N�s1��A
%       �܂��́A1�sN��̃x�N�g��
% 
% ���: 
%  StartDate = 729706
%  Convention = 0;
%
%  EndDate = m2xdate(StartDate, Convention);
%
% ���̌��ʁA���̒l���o�͂���܂��B
%
%  EndDate = 35746
%
% �Q�l : M2XDATE.


%Author(s): C. Bassignani, 11-12-97 
%   Copyright 1995-2002 The MathWorks, Inc. 
