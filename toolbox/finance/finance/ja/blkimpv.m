% BLKIMPV   Black�̃C���v���C�h�E�{���e�B���e�B
%
% V = BLKIMPV(F, X, R, T, CALL, MAXITER, TOL) �́A�����̃X�|�b�g���i F�A
% �����̃R�[���I�v�V���������s�g���i X�A���S���q�� R�A�I�v�V�����̍s�g
% ���� T�A�����̃R�[���I�v�V�������i CALL �ŗ^����ꂽ�����̉��i��
% �C���v���C�h�E�{���e�B���e�B���o�͂��܂��B
% MAXITER �́AV �ɑ΂�����ŗp������ő唽���񐔂ł��B
% �f�t�H���g�ł́AMAXITER=50 �ł��BTOL �͎����̋��e�덷�ŁA�f�t�H���g��
% 1e-6 �ł��B
%
% ����: R �� T ���������ԂɊ�Â��Ă��邱�Ƃ��m���߂Ă��������B���Ȃ킿�A
% R ���N���̏ꍇ�AT �͔N�\���łȂ���΂Ȃ�܂���B
%
% ���:  �X�|�b�g���i��$104.125�Ƃ��A�R�[���I�v�V���������s�g���i��$104�A
%        ���S���q����6.33%�̔N���ŁA�s�g���Ԃ�66���A�����ăR�[���I�v�V����
%        ���i��$1.515625�Ƃ����Ƃ��̏����̃C���v���C�h�E�{���e�B���e�B��
%        �v�Z���܂��B
%
%             v = blkimpv(104.125, 104, 0.0633, 66/365, 1.515625)
%             v =
%                     0.0833
%
% �Q�l : BLKPRICE, BLSPRICE, BLSIMPV.
%
% �Q�l���� : Hull, Options, Futures and Other Derivative Securities, 
%            2nd Edition, page 259-264. 
%            Chriss, Black-Scholes and Beyond: Option Pricing Models,
%            Chapter 4 and 8.


%   Author(s): P.N.Secakusuma, 12-15-2000, M. Reyes-Kattar 1-22-2002
%   Copyright 1995-2002 The MathWorks, Inc.  
