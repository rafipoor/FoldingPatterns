%% load data
close all
if ~exist('Data','var')
    Pattern = 'Sulc';
    load(sprintf('all%s_S1200_1096_MSMAll_cdata.mat',Pattern));
    eval(sprintf('Data = transpose(all%s_MSMAll_cdata);',Pattern));
else
    clearvars -except Data Pattern
end

DrMethod = 'isomap';
MaximumClusters  = 15;
%% Dimensionality Reduction
Y = DimensionReduction(Data,2,DrMethod);

%% Clustering
%myfunc = @(Y,K)clusterdata(Y,'linkage','ward','maxclust',K);
myfunc = @(Y,K)cluster(fitgmdist(Y,K),Y);
eva    = evalclusters(Y,myfunc,'DaviesBouldin','KList',1:MaximumClusters);
OptimumnClust = eva.OptimalK;
Idx = eva.OptimalY;

Centeroids = grpstats(Y,Idx,'mean');
Dists      = pdist2(Y,Centeroids);
[~,Representatives] = min(Dists);

%% Visualize
figure(3);
hold on
scatter(Y(:,1),Y(:,2),[],Idx,'filled')
scatter(Y(Representatives,1),Y(Representatives,2),25,'ks')
xlabel('Dimension 1');
ylabel('Dimension 2');
title(sprintf('%s-%s',DrMethod,Pattern));
axis('square')
MyPrint(sprintf('%s_%s_clusters.png',DrMethod,Pattern))


