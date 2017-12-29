%% ������������
close all
rng default;  % For reproducibility
mu1 = [1 2];
sigma1 = [3 .2; .2 2];
mu2 = [-1 -2];
sigma2 = [2 0; 0 1];
X = [mvnrnd(mu1,sigma1,200); mvnrnd(mu2,sigma2,100)];%2����˹����������
n = size(X,1);

figure;
scatter(X(1:200,1),X(1:200,2),15,'ro','filled');
hold on
scatter(X(201:end,1),X(201:end,2),15,'bo','filled')

%% ��ͼ
options = statset('Display','final'); 
gm = fitgmdist(X,2,'Options',options)

hold on
ezcontour(@(x,y)pdf(gm,[x y]),[-8 6],[-8 6]);

title('Scatter Plot and Fitted GMM Contour')
hold off

%%


idx = cluster(gm,X);
cluster1 = (idx == 1); % |1| cluster 1
cluster2 = (idx == 2); % |2| cluster 2

figure;
gscatter(X(:,1),X(:,2),idx,'rb','+o');
legend('Cluster 1','Cluster 2','Location','NorthWest');


%% ����75�����Ե�
Mu = [mu1; mu2]; 
Sigma = cat(3,sigma1,sigma2); 
p = [0.75 0.25]; 

gmTrue = gmdistribution(Mu,Sigma,p);%����һ����˹���ģ��
X0 = random(gmTrue,75);
%% ����

[idx0,~,P0] = cluster(gm,X0);

figure;
ezcontour(@(x,y)pdf(gm,[x y]),[min(X0(:,1)) max(X0(:,1))],...
    [min(X0(:,2)) max(X0(:,2))]);
hold on;
gscatter(X0(:,1),X0(:,2),idx0,'rb','+o');
legend('Fitted GMM Contour','Cluster 1','Cluster 2','Location','NorthWest');
title('New Data Cluster Assignments')
hold off;


%% ����������  
rng(3)  % For reproducibility
mu1 = [1 2];
sigma1 = [3 .2; .2 2];
mu2 = [-1 -2];
sigma2 = [2 0; 0 1];
% �����������
X = [mvnrnd(mu1,sigma1,200); mvnrnd(mu2,sigma2,100)];
 
gm = fitgmdist(X,2);
% ��������������[.4, .6]��Χ�ڣ�����Ϊ����ͬʱ
threshold = [0.4 0.6];
% ��posterior��������������X����ÿ���ɷֵĺ�����ʣ�p��n*k����
P = posterior(gm,X);
% n�����������������sort������ÿ����������ȴ�С��������ֻ��������
n = size(X,1);
[~,order] = sort(P(:,1));
figure
plot(1:n,P(order,1),'r-',1:n,P(order,2),'b-')
legend({'Cluster 1', 'Cluster 2'})
ylabel('Cluster Membership Score')
xlabel('Point Ranking')
title('GMM with Full Unshared Covariances')
%%
% ȷ��ͬʱ����������ĵ�
idx = cluster(gm,X);
idxBoth = find(P(:,1)>=threshold(1) & P(:,1)<=threshold(2)); 
numInBoth = numel(idxBoth)
figure
gscatter(X(:,1),X(:,2),idx,'rb','po',5)
hold on
plot(X(idxBoth,1),X(idxBoth,2),'ko','MarkerSize',10,'MarkerFaceColor', 'r')
legend({'Cluster 1','Cluster 2','Both Clusters'},'Location','SouthEast')
title('soft cluster')
hold off


%% GMM��Э�������
k = 3;
Sigma = {'diagonal','full'};
nSigma = numel(Sigma);
SharedCovariance = {true,false};
SCtext = {'true','false'};
nSC = numel(SharedCovariance);
d = 500;
x1 = linspace(min(X(:,1)) - 2,max(X(:,1)) + 2,d);
x2 = linspace(min(X(:,2)) - 2,max(X(:,2)) + 2,d);
[x1grid,x2grid] = meshgrid(x1,x2);
X0 = [x1grid(:) x2grid(:)];
threshold = sqrt(chi2inv(0.99,2));
options = statset('MaxIter',1000); % Increase number of EM iterations

figure;
c = 1;
for i = 1:nSigma;
    for j = 1:nSC;
        gmfit = fitgmdist(X,k,'CovarianceType',Sigma{i},...
            'SharedCovariance',SharedCovariance{j},'Options',options);
        clusterX = cluster(gmfit,X);
        mahalDist = mahal(gmfit,X0);
        subplot(2,2,c);
        h1 = gscatter(X(:,1),X(:,2),clusterX);
        hold on;
            for m = 1:k;
                idx = mahalDist(:,m)<=threshold;
                Color = h1(m).Color*0.75 + -0.5*(h1(m).Color - 1);
                h2 = plot(X0(idx,1),X0(idx,2),'.','Color',Color,'MarkerSize',1);
                uistack(h2,'bottom');
            end
        plot(gmfit.mu(:,1),gmfit.mu(:,2),'kx','LineWidth',2,'MarkerSize',10)
        title(sprintf('Sigma is %s, SharedCovariance = %s',...
            Sigma{i},SCtext{j}),'FontSize',8)
        hold off
        c = c + 1;
    end
end
