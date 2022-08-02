% UGARCH   �K�E�X�C�m�x�[�V����(Gaussian innovations)�𔺂��P�ϗ� 
%          GARCH(P,Q) �p�����[�^����
%
% [Kappa , Alpha , Beta] = ugarch(U , P , Q)
%
% ����:
%   U     : ���ϒl��0�A���U���Ԋm���ߒ������������_���ȝ�����(�v�ʌo��
%           ���f���ł́A�c���A�܂��́A�C�m�x�[�V�����ƌĂ΂�܂�)�̒P���
%           �x�N�g���B�C�m�x�[�V�������n�� U �́AGARCH(P,Q)�ߒ��ɏ]����
%           ���肳��܂��B
%   P     : GARCH �ߒ��̃��f�������������񕉂̃X�J���̐����BP �́AGARCH 
%           �ߒ��Ɋ܂܂������t�����U�̃��O���ł��BP ��0�̒l����蓾��
%           ���Ƃɒ��ӂ��Ă��������BP = 0 �̏ꍇ�AGARCH(0,Q)�ߒ��́A����
%           �� ARCH(Q)�ߒ��Ɠ����ƂȂ�܂��B
%   Q     : GARCH �v���Z�X�̃��f���������������̃X�J�������BQ �́AGARCH 
%           �ߒ��Ɋ܂܂��C�m�x�[�V�����̓��̃��O���ł��B
%
% �o��:
%   Kappa : GARCH �ߒ��̐���X�J���萔���B
%   Alpha : ���肳�ꂽ�W���� P �s1��̗�x�N�g���ł��B�����ŁAP �́A
%           GARCH �ߒ��Ɋ܂܂������t�����U�̃��O���ł��B
%   Beta  : ���肳�ꂽ�W���� Q �s1��̗�x�N�g���ł��B�����ŁAQ �́A
%           GARCH �ߒ��Ɋ܂܂��C�m�x�[�V�����̓��̃��O���ł��B
%
% ���ӁF
%   GARCH(P,Q) �W�� {Kappa, Alpha, Beta} �́A���̐���ɏ]���܂��B
%     (1)Kappa > 0
%     (2)Alpha(i)>= 0 for i = 1,2,...P
%     (3)Beta(i) >= 0 for i = 1,2,...Q
%     (4)sum(Alpha(i)+ Beta(j))<1for i = 1,2,...P and j = 1,2,...Q
%
% GARCH(P,Q) �ߒ��̎��� - �����t�����U H(t)�́A���̂悤�Ƀ��f��������
% �܂��B
%
%     H(t)= Kappa + Alpha(1)*H(t-1)+ Alpha(2)*H(t-2)+...
%              + Alpha(P)*H(t-P)+ Beta(1)*U^2(t-1)+ Beta(2)*U^2(t-2)+...
%              + Beta(Q)*U^2(t-Q)
%
% �����ŁAU �̓C�m�x�[�V�����x�N�g���A�܂��́A�v�ʌo�σ��f���̉�A�c���ŁA
% ���ϒl�� 0�ŁA���U���Ԋm���ߒ��ł��邱�Ƃɒ��ӂ��Ă��������B���Ȃ킿�A
% ��A���f���́A���Ɏ��s����AU(t)= y(t)- F(X(t),B)�����f�����瓱�o����
% ���C�m�x�[�V�����̎��n��ł���Ɖ��肵�Ă��܂��B
%
% H �́A��q�̕��������琶������܂����AU �� H �́A���̎��Ɏ������`
% �Ŋ֘A�t�����Ă��܂��B
%
% U(t) = sqrt(H(t))*v(t)�A������ {v(t)} �́A�Ɨ����ꕪ�z�f�[�^��~ N(0,1)�A
% ���Ȃ킿�A���ς�0�A���U��1�̐��K���z����f�[�^��ł��B
%
% �Q�l : UGARCHPRED, UGARCHSIM, UGARCHPLOT.


% Author(s): R.A. Baker, 08/24/1999
% Copyright 1995-2002 The MathWorks, Inc.
