% AMORTIZE   ���p
%
% [PRINP,INTP,BAL,P] = AMORTIZE(RATE,NPER,PV,FV,DUE) �́A����x������
% ����Ďx������ݕt�̌��{�����Ɨ����������o�͂��A�����̑ݕt�z�ƒ��
% �x�����̎c�����v�Z���܂��BRATE �͓K�p������������ANPER �͎x����
% ���Ԑ��APV �͑ݕt�̌��݉��l�AFV �͑ݕt�̏������l�ŁADUE �͎x������
% ���Ԃ̏����ɍs����(DUE = 1)������(DUE = 0)�ɍs���邩���w�肵�܂��B
% �f�t�H���g�́AFV = 0 �� DUE = 0 �ł��BPRINP �͊e���ԂɎx�����錳�{��
% �x�N�g���AINTP �͊e���ԂɎx�����闘���̃x�N�g���ABAL �͊e�x�������Ԃ�
% ������ݕt�̎c���AP �͎x�����֐����v�Z�������x���z�ł��B
% �o�͂� PRINP, INTP, BAL �́A1 �s NPER ��̃x�N�g���ŁAP �̓X�J���l�ł��B
% 
% ���Ƃ��΁A�N��9%�A6�񕪊������Ŏx�������󂯂� $500�̑ݕt�̉��l������
% �܂��B
%         
%   [prinp, intp, bal, p] = amortize(0.09/6, 6, 500) 
%         
% ���̌��ʂ��o�͂���܂��B
%         
%     prinp = [81.47 82.69 83.93 85.19 86.47 87.76]  
%     intp = [6.30 5.07 3.83 2.57 1.30 0.00]  
%     bal = [419.74 338.27 255.58 171.65 86.47 0.00]  
%     p = 87.76  
%    
% �Q�l : PAYPER, PAYADV, PAYODD, ANNUTERM, ANNURATE.


%       Author(s): C.F. Garvin, 2-23-95  
%       Copyright 1995-2002 The MathWorks, Inc.   
