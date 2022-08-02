% BLKPRICE   Black�̃I�v�V�������i����
%
%   [C, P] = BLKPRICE(F, X, R, T, SIG)
%
% �ڍׁF 
% ���̊֐��́A�^����ꂽ�t�H���[�h���i�A�����s�g���i�A���S���q���A����
% �܂ł̊��ԁA�{���e�B���e�B�Ɋ�Â��āA�敨���i�̃R�[���y�уv�b�g
% �I�v�V�����̉��l��Black�̃��f����p���Č��肵�܂��B
%
% ����: �@
%   F   - �[�����ɂ����錴���Y�̃t�H���[�h���i
%   X   - �R�[���A�v�b�g�I�v�V�����̌����s�g���i�̉��l
%   R   - ���S���q���̉��l(�{�����o�� - �֋X���v)
%   T   - �����A�܂��́A�I�v�V�����̖����܂ł̎��Ԃ̉��l
%   SIG - �����Y���i�̃{���e�B���e�B�̉��l
%
%   Outputs: C - �R�[���I�v�V�����̉��i
%            P - �v�b�g�I�v�V�����̉��i
%
% ���ӁF 
% R �� T ���������ԂɊ�Â��Ă��邱�Ƃ��m���߂Ă��������B���Ȃ킿�A
% R ���N���̏ꍇ�AT �͔N�\���łȂ���΂Ȃ�܂���B
%
% Black���f�����g�����āA���̂悤�Ƀt�H���[�h���i�𓱏o���邱�Ƃ�
% ���A�����f���o�e�B�u�����ɑg�ݍ��܂ꂽ�R�[���A�v�b�g�I�v�V����
% �̌^�ɕϊ����邱�Ƃ��ł��܂��B
%
%       f = (B - I)* exp(R*t)
%
% �����ŁA
%                    
%         B - ���̊z�ʉ��l
%         I - �I�v�V�����̑S���� (�[��������I�v�V�����̖����܂�)
%             �̃N�[�|���̌��݉��l 
%         R - ���S���q�� (�{�����o�� - �֋X���v)
%         t - �[��������I�v�V�����̖����܂ł̎���
%
% ���F
%       [c, p] = blkprice(95, 98, 0.11, 3, 0.025)
%
% ���̌��ʁA���̒l���o�͂���܂��B
%
%       c = 0.4162 (�܂��́A$0.42)
%       p = 2.5729 (�܂��́A$2.57)
%
% �Q�l : BINPRICE, BLSPRICE.
%
% �Q�l���� : 1) John C. Hull, Options, Futures, and Other Derivative 
%               Securities, 2nd edition.  Formulas 15.7 and 15.8.
%            2) F. Black, "The Pricing of Commodity Contracts," Journal 
%               of Financial Economics, March 3, 1976, pp. 167-79.


%   Author(s): C.F. Garvin and M. Reyes-Kattar, 12-26-95
%   Copyright 1995-2002 The MathWorks, Inc. 
