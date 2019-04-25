%% load data
if ~exist('Data','var')
    DataFolder = '~/Desktop/Noushin_Reza/';
    Pattern    = 'Myelin'; % Sulc, Thickness
    load(fullfile(DataFolder,sprintf('all%s_S1200_1096_MSMAll_cdata.mat',Pattern)));
    eval(sprintf('Data = transpose(all%s_MSMAll_cdata);',Pattern));
else
    clearvars -except Data Pattern
end
DrMethod = 'isomap';

%% Dimensionality Reduction
LowDMap = DimensionReduction(Data,2,DrMethod);

%% Clustering
Labels  = DBSCANAutoTuned(LowDMap,20);
OutLiers= Labels==0;
Centers = grpstats(LowDMap(~OutLiers,:),Labels(~OutLiers),'mean');
Dists   = pdist2(LowDMap,Centers);
[~,Rep] = min(Dists);
suptitle(sprintf('%s-Whole',Pattern))
MyPrint(sprintf('%s_WholeBrain_DBSCAN_Tuning.png',Pattern))
%% Visualize
figure;
hold on
scatter(LowDMap(~OutLiers,1),LowDMap(~OutLiers,2),[],Labels(~OutLiers),'filled')
scatter(LowDMap(OutLiers,1),LowDMap(OutLiers,2),[],'k')
scatter(LowDMap(Rep,1),LowDMap(Rep,2),50,'ks','filled')
xlabel('Dimension 1'); ylabel('Dimension 2');
title(sprintf('%s-Whole Brain',Pattern));
axis('square')

MyPrint(sprintf('%s_WholeBrainClusters.png',Pattern));
save(sprintf('%s_WholeBrainClustLabels.mat',Pattern),'LLabels','RLabels');
