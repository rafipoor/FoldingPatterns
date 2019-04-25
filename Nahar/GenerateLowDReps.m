clear;
close all;
%% Parameters
Params.Isomapk        = 8;
Params.DBSCanMinPts   = 20;
Params.DBSCANErrRatio = 1.05;
DrMethod = 'isomap';

%%
DataDir = '.';% '../../Desktop/NaharData/'; % add data folder to path
addpath(DataDir);
Patterns  = {'Curvature','Thickness','Sulc'};

Data  = cell(numel(Patterns),1);
for i = 1:numel(Patterns)
    load(fullfile(DataDir,sprintf('all%s_S1200_1096_MSMAll_cdata.mat',Patterns{i})));
    eval(sprintf('Data{i} = transpose(all%s_MSMAll_cdata);',Patterns{i}));
    eval(sprintf('clear all%s_MSMAll_cdata',Patterns{i}));
end
%%
load('HemisphereIdx.mat');
LeftIdx  = HemisphereIdx(:,3)==1;
RightIdx = HemisphereIdx(:,3)==2;

%%
LowDReps = struct('Whole',[],'Left',[],'Right',[],...
    'LabelsWhole',[],'LabelsLeft',[],'LabelsRight',[],'Name',[]);
LowDReps(1:numel(Patterns))= LowDReps;
%% dimension reduction
parfor i = 1:numel(Patterns)
    LowDReps(i).Name        = Patterns{i};
    LowDReps(i).Whole       = DimensionReduction(Data{i},2,DrMethod,Params.Isomapk);
    LowDReps(i).Left        = DimensionReduction(Data{i}(:,LeftIdx),2,DrMethod,Params.Isomapk);
    LowDReps(i).Right       = DimensionReduction(Data{i}(:,RightIdx),2,DrMethod,Params.Isomapk);
end
%% clustering
for i = 1:numel(Patterns)
    LowDReps(i).LabelsWhole = DBSCANAutoTuned(LowDReps(i).Whole,Params.DBSCanMinPts,Params.DBSCANErrRatio);
    LowDReps(i).LabelsLeft  = DBSCANAutoTuned(LowDReps(i).Left,Params.DBSCanMinPts,Params.DBSCANErrRatio);
    LowDReps(i).LabelsRight = DBSCANAutoTuned(LowDReps(i).Right,Params.DBSCanMinPts,Params.DBSCANErrRatio);
end


fName = sprintf('LowDRepsAll_Err%1.2f_K%d_M%d.mat',Params.DBSCANErrRatio,Params.Isomapk,Params.DBSCanMinPts);
save(fName,'LowDReps','Params');

%%
for i=1:numel(Patterns)
    figure('Units','Normalized','Position',[0 0 1 1]);
    FieldNames = fieldnames(LowDReps);
    for j = 1:3
        subplot(1,3,j);hold on
        Y = getfield(LowDReps(i),FieldNames{j});
        L = getfield(LowDReps(i),FieldNames{j+3});
        scatter(Y(L~=0,1),Y(L~=0,2),[],L(L~=0),'filled')
        scatter(Y(L==0,1),Y(L==0,2),[],'k')
        xlabel('Dimension 1'); ylabel('Dimension 2');
        title(FieldNames{j})
        axis('equal','square')
    end
    suptitle([Patterns{i} '-' DrMethod]);
    MyPrint(sprintf('LowDReps_%s_%s.png',Patterns{i},DrMethod));
end
