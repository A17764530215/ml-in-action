%% ���һ��GMMģ��
%% 
% ����������ά�ķ��Ӹ�˹��
close all
clear
mu1 = [1 2];
Sigma1 = [2 0; 0 0.5];
mu2 = [-3 -5];
Sigma2 = [1 0;0 1];
rng(1); % For reproducibility
X = [mvnrnd(mu1,Sigma1,1000);mvnrnd(mu2,Sigma2,1000)];% �ϳɵ�����
%%
% ģ����ϣ�����2���ɷ�
gm = fitgmdist(X,2);
%%
% ������ϵĸ�˹ģ��
figure
y = [zeros(1000,1);ones(1000,1)];
h = gscatter(X(:,1),X(:,2),y);
hold on
ezcontour(@(x1,x2)pdf(gm,[x1 x2]),get(gca,{'XLim','YLim'}))
title('{\bf Scatter Plot and Fitted Gaussian Mixture Contours}')
legend(h,'Model 0','Model1')
hold off

%% ��ӡ����
properties(gm)

%%
mu1 = [1 2];
Sigma1 = [1 0; 0 1];
mu2 = [3 4];
Sigma2 = [0.5 0; 0 0.5];
rng(1); % For reproducibility
X1 = [mvnrnd(mu1,Sigma1,100);mvnrnd(mu2,Sigma2,100)];
X = [X1,X1(:,1)+X1(:,2)];% ��������к�ǰ������������صģ�������׳��ֲ�̬�����

rng(1); % Ϊ���ظ���fit GMM�ǳ�ʼֵ��ѡȡ�������
try
    GMModel = fitgmdist(X,2)
catch exception
    disp('���ʱ����������')
    error = exception.message
end

rng(1); % Reset seed for common start values
GMModel = fitgmdist(X,2,'RegularizationValue',0.1)

%% ���GMMʱ��kѡ������
% ����pca����̽��

% �������ݼ���������ݼ���UCI��������Ϣ���Բ鿴UCI��վ
load fisheriris
classes = unique(species)
% meas����Ҫ�������ݣ�4ά
% ��pca�㷨��ԭʼ���ݽ�ά��score�������Ӵ�С���еĽ��
[~,score] = pca(meas,'NumComponents',2);

% �ֱ���ʹ�ò�ͬ��k���������
GMModels = cell(3,1); % Preallocation
options = statset('MaxIter',1000);
rng(1); % For reproducibility

for j = 1:3
    GMModels{j} = fitgmdist(score,j,'Options',options);
    fprintf('\n GM Mean for %i Component(s)\n',j)
    Mu = GMModels{j}.mu
end

figure
for j = 1:3
    subplot(2,2,j)
    % gscatter���Ը����飨Ҳ����label�����ֵĻ���ɢ��ͼ
    % ��������2ά����Ϣ�����ӻ�
    gscatter(score(:,1),score(:,2),species)
    h = gca;
    hold on
    ezcontour(@(x1,x2)pdf(GMModels{j},[x1 x2]),...
        [h.XLim h.YLim],100)
    title(sprintf('GM Model - %i Component(s)',j));
    xlabel('1st principal component');
    ylabel('2nd principal component');
    if(j ~= 3)
        legend off;
    end
    hold off
end
g = legend;
g.Position = [0.7 0.25 0.1 0.1];