%% load data
DataFolder = '~/Desktop/Noushin_Reza/';
if ~exist('Data','var')
    Pattern = 'Myelin'; % Sulc, Thickness
    load(fullfile(DataFolder,sprintf('all%s_S1200_1096_MSMAll_cdata.mat',Pattern)));
    eval(sprintf('Data = transpose(all%s_MSMAll_cdata);',Pattern));
else
    clearvars -except Data Pattern
end
load('HemisphereIdx.mat');
DrMethod = 'isomap';

%% Dimensionality Reduction
XL = Data(:,HemisphereIdx(:,3)==1);
XR = Data(:,HemisphereIdx(:,3)==2);

YL = DimensionReduction(XL,2,DrMethod);
YR = DimensionReduction(XR,2,DrMethod);
%% Clustering
LLabels  = DBSCANAutoTuned(YL,20);
OutLiersL= LLabels==0;
CentersL = grpstats(YL(~OutLiersL,:),LLabels(~OutLiersL),'mean');
DistsL   = pdist2(YL,CentersL);
[~,RepL] = min(DistsL);
suptitle(sprintf('%s-Left',Pattern))
MyPrint(sprintf('%s_Left_DBSCAN_Tuning.png',Pattern));

RLabels  = DBSCANAutoTuned(YR,20);
OutLiersR= RLabels==0;
CentersR = grpstats(YR(~OutLiersR,:),RLabels(~OutLiersR),'mean');
DistsR   = pdist2(YR,CentersR);
[~,RepR] = min(DistsR);
suptitle(sprintf('%s-Right',Pattern))
MyPrint(sprintf('%s_Right_DBSCAN_Tuning.png',Pattern));
%% Visualize
figure;
subplot(2,2,1)
hold on
scatter(YL(~OutLiersL,1),YL(~OutLiersL,2),[],LLabels(~OutLiersL),'filled')
scatter(YL(OutLiersL,1),YL(OutLiersL,2),[],'k')
scatter(YL(RepL,1),YL(RepL,2),50,'ks','filled')
xlabel('Dimension 1'); ylabel('Dimension 2');
title(sprintf('%s-Left',Pattern));
axis('square')

subplot(2,2,2)
hold on
scatter(YR(~OutLiersR,1),YR(~OutLiersR,2),[],RLabels(~OutLiersR),'filled')
scatter(YR(OutLiersR,1),YR(OutLiersR,2),[],'k')
scatter(YR(RepR,1),YR(RepR,2),50,'ks','filled')
xlabel('Dimension 1'); ylabel('Dimension 2');
title(sprintf('%s-Right',Pattern));
axis('square')


subplot(2,2,3)
hold on
scatter(YL(~OutLiersR,1),YL(~OutLiersR,2),[],RLabels(~OutLiersR),'filled')
scatter(YL(OutLiersR,1),YL(OutLiersR,2),[],'k')
scatter(YL(RepL,1),YL(RepL,2),50,'ks','filled')
xlabel('Dimension 1'); ylabel('Dimension 2');
title(sprintf('%s-Left-Crossed Color',Pattern));
axis('square')

subplot(2,2,4)
hold on
scatter(YR(~OutLiersL,1),YR(~OutLiersL,2),[],LLabels(~OutLiersL),'filled');
scatter(YR(OutLiersL,1),YR(OutLiersL,2),[],'k');
scatter(YR(RepR,1),YR(RepR,2),50,'ks','filled')
xlabel('Dimension 1'); ylabel('Dimension 2');
title(sprintf('%s-Right-Crossed Color',Pattern));
axis('square')
suptitle(Pattern);
MyPrint(sprintf('%s_TwoHemispheres.png',Pattern));
save(sprintf('%s_HemiClustLabels.mat',Pattern),'LLabels','RLabels');
