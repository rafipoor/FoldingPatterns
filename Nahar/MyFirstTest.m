close all
if ~exist('Data','var')
    load allCurvature_S1200_1096_MSMAll_cdata.mat
    Data = allCurvature_MSMAll_cdata';
else
    clearvars -except Data
end

DrMethods = {'pca','isomap','lle','tsne','aut','sammon','nmds','metricmds'};
MaximumClusters  = 8;

for i=1:numel(DrMethods)
    %% Dimensionality Reduction
    Y = DimensionReduction(Data,2,DrMethods{i});
    %% Clustering
    Idx = clusterdata(Y,'linkage','ward','maxclust',MaximumClusters);
    
    %% Visualize
    scatter(Y(:,1),Y(:,2),[],Idx,'filled')
    xlabel('Dimension 1');
    ylabel('Dimension 2');
    title(DrMethods{i});
    axis('square')
    MyPrint(sprintf('%s.png',DrMethods{i}))
end
%%

