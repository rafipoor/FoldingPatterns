close all
if ~exist('Data','var')
    load allCurvature_S1200_1096_MSMAll_cdata.mat
    Data = allCurvature_MSMAll_cdata';
else
    clearvars -except Data
end
Pattern  = 'Curvature';
DrMethod = 'isomap';
MaximumClusters  = 8;

%% Dimensionality Reduction
Y = DimensionReduction(Data,2,DrMethod);
%% Clustering
Idx = clusterdata(Y,'linkage','ward','maxclust',MaximumClusters);

Centeroids = grpstats(Y,Idx,'mean');
Dists      = pdist2(Y,Centeroids);
[~,Representatives] = min(Dists);

%% Visualize
hold on
scatter(Y(:,1),Y(:,2),[],Idx,'filled')
scatter(Y(Representatives,1),Y(Representatives,2),25,'ks')
xlabel('Dimension 1');
ylabel('Dimension 2');
title(sprintf('%s-%s',DrMethod,Pattern));
axis('square')
MyPrint(sprintf('%s_%s_clusters.png',DrMethod,Pattern))
