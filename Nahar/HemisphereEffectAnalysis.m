%% load data
DataFolder = '~/Desktop/Noushin_Reza/';
close all
if ~exist('Data','var')
    Pattern = 'Curvature'; % Sulc, Thickness
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
YT = DimensionReduction(Data,2,DrMethod);

%% Clustering
IdxL     = DBSCANAutoTuned(YL,20);
OutLiersL= IdxL==0;
CentersL = grpstats(YL(~OutLiersL,:),IdxL(~OutLiersL),'mean');
DistsL   = pdist2(YL,CentersL);
[~,RepL] = min(DistsL);

IdxR = DBSCANAutoTuned(YR,20);
OutLiersR= IdxR==0;
CentersR = grpstats(YR(~OutLiersR,:),IdxR(~OutLiersR),'mean');
DistsR   = pdist2(YR,CentersR);
[~,RepR] = min(DistsR);

%% Visualize
figure;
subplot(2,2,1)
hold on
scatter(YL(~OutLiersL,1),YL(~OutLiersL,2),[],IdxL(~OutLiersL),'filled')
scatter(YL(OutLiersL,1),YL(OutLiersL,2),[],'k')
scatter(YL(RepL,1),YL(RepL,2),50,'ks','filled')
xlabel('Dimension 1'); ylabel('Dimension 2');
title(sprintf('%s-Left',Pattern));
axis('square')

subplot(2,2,2)
hold on
scatter(YR(~OutLiersR,1),YR(~OutLiersR,2),[],IdxR(~OutLiersR),'filled')
scatter(YR(OutLiersR,1),YR(OutLiersR,2),[],'k')
scatter(YR(RepR,1),YR(RepR,2),50,'ks','filled')
xlabel('Dimension 1'); ylabel('Dimension 2');
title(sprintf('%s-Right',Pattern));
axis('square')


subplot(2,2,3);
hold on
scatter(YT(~OutLiersL,1),YT(~OutLiersL,2),[],IdxL(~OutLiersL),'filled')
scatter(YT(OutLiersL,1),YT(OutLiersL,2),[],'k')
scatter(YT(RepL,1),YT(RepL,2),50,'ks','filled')
xlabel('Dimension 1'); ylabel('Dimension 2');
title(sprintf('%s-Left',Pattern));
axis('square')

subplot(2,2,4)
hold on
scatter(YT(~OutLiersR,1),YT(~OutLiersR,2),[],IdxR(~OutLiersR),'filled')
scatter(YT(OutLiersR,1),YT(OutLiersR,2),[],'k')
scatter(YT(RepR,1),YT(RepR,2),50,'ks','filled')
xlabel('Dimension 1'); ylabel('Dimension 2');
title(sprintf('%s-Right',Pattern));
axis('square')


MyPrint(sprintf('%s_HemisphereEffects.png',Pattern))

%%
nCL = numel(unique(IdxL))-1;
nCR = numel(unique(IdxR))-1;
figure
hold on
MrkrTypes = {'o','s','d','x','v'};
MrkrColors = distinguishable_colors(6);
for i=1:nCL
    for j=1:nCR
        Idx = IdxL == i & IdxR == j;
        scatter(YT(Idx,1),YT(Idx,2),20,'MarkerFaceColor',...
            MrkrColors(i,:),'MarkerEdgeColor',MrkrColors(i,:),...
            'Marker',MrkrTypes{j});
    end 
end
axis('square');
