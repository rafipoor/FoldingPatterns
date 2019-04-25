clear;
close all;
DataFolder = '~/Desktop/Noushin_Reza/';
Patterns  = {'Curvature','Thickness','Sulc','Myelin'};
DrMethods = {'PCA','MDS','Isomap'};

Data  = cell(numel(Patterns),1);
for i = 1:numel(Patterns)
    load(fullfile(DataFolder,sprintf('all%s_S1200_1096_MSMAll_cdata.mat',Patterns{i})));
    eval(sprintf('Data{i} = transpose(all%s_MSMAll_cdata);',Patterns{i}));
    eval(sprintf('clear all%s_MSMAll_cdata',Patterns{i}));
end

%% page1

k = 0;
figure;
for i = 1:numel(Patterns)
    for j = 1:numel(DrMethods)
        Y2 = DimensionReduction(Data{i},2,DrMethods{j});
        k = k+1;
        subplot(4,3,k)
        scatter(Y2(:,1),Y2(:,2),4,'k','filled');
        title(sprintf('%s-%s',DrMethods{j},Patterns{i}));
        axis('square','tight');
    end
end
MyPrint('Page1.png');
%% Page 2:
LowDMap = DimensionReduction(Data{1},2,DrMethods{3});
DBSCANAutoTuned(LowDMap,20);
suptitle(sprintf('%s-Whole',Patterns{1}))
MyPrint('Page2.png')

%% Page 3
load('HemisphereIdx.mat');
XL = Data{1}(:,HemisphereIdx(:,3)==1);
YL = DimensionReduction(XL,2,DrMethods{3});
LLabels  = DBSCANAutoTuned(YL,20);
suptitle(sprintf('%s-Left',Patterns{1}))
MyPrint('Page3_1.png');

XR = Data{1}(:,HemisphereIdx(:,3)==2);
YR = DimensionReduction(XR,2,DrMethods{3});
RLabels  = DBSCANAutoTuned(YR,20);
suptitle(sprintf('%s-Right',Patterns{1}))
MyPrint('Page3_2.png');

%% page 4
figure;

LOutLiers= LLabels==0;
LCenters = grpstats(YL(~LOutLiers,:),LLabels(~LOutLiers),'mean');
LDists   = pdist2(YL,LCenters);
[~,LRep] = min(LDists);

ROutLiers= RLabels==0;
RCenters = grpstats(YR(~ROutLiers,:),RLabels(~ROutLiers),'mean');
RDists   = pdist2(YR,RCenters);
[~,RRep] = min(RDists);

ax = tight_subplot(2,2,[.1,-.25]);
axes(ax(1));
hold on
scatter(YL(~LOutLiers,1),YL(~LOutLiers,2),[],LLabels(~LOutLiers),'filled')
scatter(YL(LOutLiers,1),YL(LOutLiers,2),[],'k')
scatter(YL(LRep,1),YL(LRep,2),50,'ks','filled')
xlabel('Dimension 1'); ylabel('Dimension 2');
title(sprintf('%s-Left',Patterns{1}));
axis('square')

axes(ax(2));
hold on
scatter(YR(~ROutLiers,1),YR(~ROutLiers,2),[],RLabels(~ROutLiers),'filled')
scatter(YR(ROutLiers,1),YR(ROutLiers,2),[],'k')
scatter(YR(RRep,1),YR(RRep,2),50,'ks','filled')
xlabel('Dimension 1'); ylabel('Dimension 2');
title(sprintf('%s-Right',Patterns{1}));
axis('square')


axes(ax(3));
hold on
scatter(YL(~ROutLiers,1),YL(~ROutLiers,2),[],RLabels(~ROutLiers),'filled')
scatter(YL(ROutLiers,1),YL(ROutLiers,2),[],'k')
scatter(YL(LRep,1),YL(LRep,2),50,'ks','filled')
xlabel('Dimension 1'); ylabel('Dimension 2');
title(sprintf('%s-Left-Crossed Color',Patterns{1}));
axis('square')

axes(ax(4));
hold on
scatter(YR(~LOutLiers,1),YR(~LOutLiers,2),[],LLabels(~LOutLiers),'filled');
scatter(YR(LOutLiers,1),YR(LOutLiers,2),[],'k');
scatter(YR(RRep,1),YR(RRep,2),50,'ks','filled')
xlabel('Dimension 1'); ylabel('Dimension 2');
title(sprintf('%s-Right-Crossed Color',Patterns{1}));
axis('square')
MyPrint('Page4.png');

%% page 5
LowDMap = DimensionReduction(Data{2},2,DrMethods{3});
DBSCANAutoTuned(LowDMap,20);
suptitle(sprintf('%s-Whole',Patterns{2}))
MyPrint('Page5.png')

%% Page 6
XL = Data{2}(:,HemisphereIdx(:,3)==1);
YL = DimensionReduction(XL,2,DrMethods{3});
LLabels  = DBSCANAutoTuned(YL,20);
suptitle(sprintf('%s-Left',Patterns{2}))
MyPrint('Page6_1.png');

XR = Data{2}(:,HemisphereIdx(:,3)==2);
YR = DimensionReduction(XR,2,DrMethods{3});
RLabels  = DBSCANAutoTuned(YR,20);
suptitle(sprintf('%s-Right',Patterns{2}))
MyPrint('Page6_2.png');

%% page 7
figure;

LOutLiers= LLabels==0;
LCenters = grpstats(YL(~LOutLiers,:),LLabels(~LOutLiers),'mean');
LDists   = pdist2(YL,LCenters);
[~,LRep] = min(LDists);

ROutLiers= RLabels==0;
RCenters = grpstats(YR(~ROutLiers,:),RLabels(~ROutLiers),'mean');
RDists   = pdist2(YR,RCenters);
[~,RRep] = min(RDists);
ax = tight_subplot(2,2,[.1,-.25]);
axes(ax(1));
hold on
scatter(YL(~LOutLiers,1),YL(~LOutLiers,2),[],LLabels(~LOutLiers),'filled')
scatter(YL(LOutLiers,1),YL(LOutLiers,2),[],'k')
scatter(YL(LRep,1),YL(LRep,2),50,'ks','filled')
xlabel('Dimension 1'); ylabel('Dimension 2');
title(sprintf('%s-Left',Patterns{2}));
axis('square')

axes(ax(2));
hold on
scatter(YR(~ROutLiers,1),YR(~ROutLiers,2),[],RLabels(~ROutLiers),'filled')
scatter(YR(ROutLiers,1),YR(ROutLiers,2),[],'k')
scatter(YR(RRep,1),YR(RRep,2),50,'ks','filled')
xlabel('Dimension 1'); ylabel('Dimension 2');
title(sprintf('%s-Right',Patterns{2}));
axis('square')

axes(ax(3));
hold on
scatter(YL(~ROutLiers,1),YL(~ROutLiers,2),[],RLabels(~ROutLiers),'filled')
scatter(YL(ROutLiers,1),YL(ROutLiers,2),[],'k')
scatter(YL(LRep,1),YL(LRep,2),50,'ks','filled')
xlabel('Dimension 1'); ylabel('Dimension 2');
title(sprintf('%s-Left-Crossed Color',Patterns{2}));
axis('square')

axes(ax(4));
hold on
scatter(YR(~LOutLiers,1),YR(~LOutLiers,2),[],LLabels(~LOutLiers),'filled');
scatter(YR(LOutLiers,1),YR(LOutLiers,2),[],'k');
scatter(YR(RRep,1),YR(RRep,2),50,'ks','filled')
xlabel('Dimension 1'); ylabel('Dimension 2');
title(sprintf('%s-Right-Crossed Color',Patterns{2}));
axis('square')
MyPrint('Page7.png');

%% Page 8
LowDMap = DimensionReduction(Data{3},2,DrMethods{3});
DBSCANAutoTuned(LowDMap,20);
suptitle(sprintf('%s-Whole',Patterns{3}))
MyPrint('Page8.png')

%% Page 9
XL = Data{3}(:,HemisphereIdx(:,3)==1);
YL = DimensionReduction(XL,2,DrMethods{3});
DBSCANAutoTuned(YL,20);
suptitle(sprintf('%s-Left',Patterns{3}))
MyPrint('Page9_1.png');

XR = Data{3}(:,HemisphereIdx(:,3)==2);
YR = DimensionReduction(XR,2,DrMethods{3});
DBSCANAutoTuned(YR,20);
suptitle(sprintf('%s-Right',Patterns{3}))
MyPrint('Page9_2.png');

%% Page 10
LowDMap = DimensionReduction(Data{4},2,DrMethods{3});
Labels  = DBSCANAutoTuned(LowDMap,20);
suptitle(sprintf('%s-Whole',Patterns{4}))
MyPrint('Page10.png')

%% Page 11
XL = Data{4}(:,HemisphereIdx(:,3)==1);
YL = DimensionReduction(XL,2,DrMethods{3});
LLabels  = DBSCANAutoTuned(YL,20);
suptitle(sprintf('%s-Left',Patterns{4}))
MyPrint('Page11_1.png');

XR = Data{4}(:,HemisphereIdx(:,3)==2);
YR = DimensionReduction(XR,2,DrMethods{3});
RLabels  = DBSCANAutoTuned(YR,20);
suptitle(sprintf('%s-Right',Patterns{4}))
MyPrint('Page11_2.png');
