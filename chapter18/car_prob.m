
%%���Ե�����������⳵����
clc; clear;
close all; 
% ��������
max_n_cars = 20;        % ����⳵��: 
gamma = 0.9;            % �ۿ�ϵ��
transfer_car = 5;       % ÿ������ת�Ƴ�����
lambda_A_return = 3;    % A��˾ƽ��ÿ��黹�ĳ�����
lambda_A_rental = 3;    % A��˾ÿ�쳵����ƽ��������
lambda_B_return = 2;    % B��˾ƽ��ÿ��黹�ĳ�����
lambda_B_rental = 4;    % B��˾ÿ�쳵����ƽ��������

%����ر���ת�Ƹ��� 
[Ra,Pa] = cmpt_P_and_R(lambda_A_rental,lambda_A_return,max_n_cars,transfer_car);
[Rb,Pb] = cmpt_P_and_R(lambda_B_rental,lambda_B_return,max_n_cars,transfer_car);

% ��ʼ��ֵ���� 
V = zeros(max_n_cars+1,max_n_cars+1); 
% ��ʼ����
pol_pi = zeros(max_n_cars+1,max_n_cars+1); 
policyStable = 0; iterNum = 0; 
% ��ʼ���Ե��������Ը����ȶ���ֹͣ����
while( ~policyStable )
  % plot the current policy:
  figure('Position', [200 100+200*iterNum 580 200]);    % ��������������࣬Ӧ����ͼ��λ��
  subplot(1,2,1)
  imagesc( 0:max_n_cars, 0:max_n_cars, pol_pi ); colorbar; xlabel( 'num at B' ); ylabel( 'num at A' );
  title( ['��ǰ���� iter=', num2str(iterNum)] ); axis xy; drawnow;
  set(gca, 'FontSize', 9);

  % ���Ƶ�ǰ�����µ�״ֵ̬���� 
  V = jcr_policy_evaluation(V,pol_pi,gamma,Ra,Pa,Rb,Pb,transfer_car);
  subplot(122)
  imagesc( 0:max_n_cars, 0:max_n_cars, V ); colorbar; 
  xlabel( 'num at B' ); ylabel( 'num at A' ); 
  title( ['��ǰ״ֵ̬���� iter=', num2str(iterNum)] ); axis xy; drawnow; 
  set(gca, 'FontSize', 9);
 
  % �������µ�ֵ������������ 
  [pol_pi,policyStable] = jcr_policy_improvement(pol_pi,V,gamma,Ra,Pa,Rb,Pb,transfer_car);
  % ��һ�ε���
  iterNum=iterNum+1; 
end






