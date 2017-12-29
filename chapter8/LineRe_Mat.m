%Matlab���Իع��㷨Matlabʵ��
clear all;
close all;
clc;
load carsmall  %������������
tbl = table(Weight,Acceleration,MPG,'VariableNames'...
,{'Weight','Acceleration','MPG'});
lm = fitlm(tbl,'MPG~Weight+Acceleration') %��Weight��AccelerationΪ�Ա�����MPGΪ����������Իع�
plot3(Weight,Acceleration,MPG,'*') %�������ݵ�ͼ
hold on
axis([min(Weight)+2 max(Weight)+2 min(Acceleration)+1 max(Acceleration)+1 min(MPG)+1 max(MPG)+1]) 
title('��Ԫ�ع�')  %�༭ͼ������
xlabel('Weight')  %�༭x����������
ylabel('Acceleration')  %�༭y����������
zlabel('MPG')  %�༭y����������
X=min(Weight):20:max(Weight)+2 ;  %�������ڻ��ƶ�Ԫ������X������
Y=min(Acceleration):max(Acceleration)+1;%�������ڻ��ƶ�Ԫ������Y������
[XX,YY]=meshgrid(X,Y); %����XY�����������
Estimate = table2array(lm.Coefficients); %������õ���table��ʽ����ϲ���ת��Ϊ������ʽ
Z=Estimate(1,1)+Estimate(2,1)*XX+Estimate(3,1)*YY;%����������Z������       
mesh(XX,YY,Z) %����������ʽ�Ķ�Ԫ�����
hold off

