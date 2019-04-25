%% load data
close all
if ~exist('Data','var')
    Pattern = 'Thickness';
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
% figure(1);
% Sil= nan(1,MaximumClusters);
% for nClusters = 2:MaximumClusters
%     Idx = clusterdata(Y,'linkage','ward','maxclust',nClusters); 
%     Sil(nClusters) = mean(silhouette(Y,Idx));
% end
% plot(1:MaximumClusters, Sil,'r');
% [~,OptimumnClust] =  max(Sil);
% Idx = clusterdata(Y,'linkage','ward','maxclust',OptimumnClust);


eva = evalclusters(Y,'kmeans','gap','KList',1:MaximumClusters);
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


