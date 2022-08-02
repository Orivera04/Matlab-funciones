% X2MDATE   Excel�V���A�����t�ԍ�������MATLAB�V���A�����t�ԍ������֕ϊ�
%
%     DateNumber = x2mdate(ExcelDateNumber, Convention)
%
% �ڍ�: ���̊֐��́AExcel�V���A�����t�ԍ�������MATLAB�V���A�����t�ԍ�
%       �����֕ϊ����܂��B
%
% ����: 
% ExcelDateNumber - Excel�V���A�����t�ԍ������Ŏ����ꂽ�V���A�����t�ԍ�
%                   ��N�s1��A�܂��́A1�sN��x�N�g���ł��B
%  
% Convention      -  Excel��œ��t�����񂩂�V���A�����t�ԍ��ւ̕ϊ���
%                    �s���ۂɁA�ǂ̃V���A�����t�ԍ��ϊ��K����p���邩��
%                    ����N�s1��A�܂��́A1�sN��x�N�g���A�܂��́A�X�J��
%                    �t���O�l�ł��B�ݒ�ł���l�́A���̒ʂ�ƂȂ�܂��B
%              
%                    a) Convention = 0 - �V���A�����t�ԍ�1��1899�N12��31
%                                        ���ɑΉ�����1900���t�V�X�e��
%                                        (�f�t�H���g)
%                    b) Convention = 1 - �V���A�����t�ԍ�0��1904�N1��1��
%                                        �ɑΉ�����1904���t�V�X�e��
%
% �o��: MATLAB�V���A�����t�ԍ��`���ŕ\�����ꂽ�V���A�����t�ԍ���N�s1��A
%       �܂��́A1�sN��x�N�g���ł��B
%
% ���: 
%  StartDate = 35746
%  Convention = 0;
%
%  EndDate = x2mdate(StartDate, Convention);
%
% ���̌��ʁA���̒l���o�͂���܂��B
%
%  EndDate = 729706
%
% �Q�l : M2XDATE.


%Author(s): C. Bassignani, 11-12-97 
%   Copyright 1995-2002 The MathWorks, Inc.
