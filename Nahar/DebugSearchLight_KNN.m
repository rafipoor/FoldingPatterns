close all;

%% load Data
DataFolder = './';
Pattern  = {'Curvature'};
DrMethod = {'Isomap'};
if ~exist('Data','var')
    for i = 1:numel(Pattern)
        load(fullfile(DataFolder,sprintf('all%s_S1200_1096_MSMAll_cdata.mat',Pattern{i})));
        eval(sprintf('Data = transpose(all%s_MSMAll_cdata);',Pattern{i}));
        eval(sprintf('clear all%s_MSMAll_cdata',Pattern{i}));
    end
else
    clearvars -except Data
end
load('HemisphereIdx.mat');
load('SearchLightIdx.mat');
load('ClusteringResults.mat');
%% Parameteres:
CVFolds = 5;
K = 15;

%% Search Light
% left hemisphere
LeftData    = Data(:,HemisphereIdx(:,3)==1);
nVertex     = size(LeftData,2);
ClassLabels = randi(4,[1096,1]);%LLabels(randperm(numel(LLabels)));
nClasses    = numel(unique(ClassLabels(ClassLabels~=0)));
LeftMaps    = zeros(nVertex,nchoosek(nClasses,2));

for i=1:nVertex
    Patch = LeftData(:,LSearchLightIdx(i,:));
    CVPerf = zeros(nClasses,nClasses);
    for c1 = 1:1
        XC1 = Patch(ClassLabels==c1,:);
        for c2 = 3:3
            XC2 = Patch(ClassLabels==c2,:);
            X  = [XC1;XC2];
            Y  = [ones(size(XC1,1),1); 2*ones(size(XC2,1),1)];
            Dists = squareform(pdist(X));
            [~,Idx] = sort(Dists);
            Neighbs = Idx(2:(K+1),:)';
            NeighbsLabel  = Y(Neighbs);
            Predicted     = mode(NeighbsLabel,2);
            CVPerf(c1,c2) = mean(Y == Predicted);
        end
    end
    LeftMaps(i,:) = squareform(CVPerf + CVPerf');
    if mod(i,500)==0
        disp(i);
    end
end
save('LeftKNNResults','LeftMaps');
%%
figure('Units','Normalized','Position',[0 0 1 1],'Color','w');
ax = tight_subplot(4,4,.075);
k = 0;
for c1 = 1:4
    for c2 = 1:4
        sIdx = sub2ind([4,4],c1,c2);
        axes(ax(sIdx));
        if c2>c1
            k = k+1;
            colormap('hot');
            Performances = LeftMaps(:,k);
            hist(Performances,0.3:0.01:1);
            xlim([0.4,1.1]);
            title(sprintf('%d vs %d',c1,c2));
        else
            axis('off');
        end
    end
end

