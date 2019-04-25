close all
clear
Patterns = {'Thickness'};
nBootStraps = 100;

DrMethod  = 'isomap';
MaxClusts = 20;
ClustFunc = @(Y,K)clusterdata(Y,'linkage','ward','maxclust',K);

%% 
for pi = 1:numel(Patterns)
    Pattern     = Patterns{pi};
    load(sprintf('all%s_S1200_1096_MSMAll_cdata.mat',Pattern));
    eval(sprintf('Data = transpose(all%s_MSMAll_cdata);',Pattern));
    
    nSubjects   = size(Data,1);
    nSamples    = 800;
    
    ClustObj  = cell(nBootStraps,1);
    SubIdx    = zeros(nSamples,nBootStraps);
    

    %%
    for i = 1:nBootStraps
        SubIdx(:,i) = sort(randsample(nSubjects,nSamples,0));
        ThisData    = Data(SubIdx(:,i),:);
        LowdMap     = DimensionReduction(ThisData,2,DrMethod);
        ClustObj{i} = evalclusters(LowdMap,ClustFunc,'gap','KList',1:MaxClusts);
        disp(i);
    end
    %%
    OptimalK = cellfun(@(x) getfield(x,'OptimalK'), ClustObj);
    LowDMaps = cellfun(@(x) getfield(x,'X'), ClustObj,'UniformOutput',0);
    ClustIdx = cellfun(@(x) getfield(x,'OptimalY'), ClustObj,'UniformOutput',0);
    
    for i = 1:nBootStraps
        tmp    = nan(nSubjects,2);
        tmp(SubIdx(:,i),:) = LowDMaps{i};
        LowDMaps{i} = tmp;
        
        tmp    = nan(nSubjects,1);
        tmp(SubIdx(:,i)) = ClustIdx{i};
        ClustIdx{i} = tmp;
        scatter(LowDMaps{i}(:,1),LowDMaps{i}(:,2),[],ClustIdx{i},'filled');
        title(i);    xlabel('Dimension 1');    ylabel('Dimension 2'); axis('square');
        pause(0.2);
    end
    %%
    LowDRDMs = cellfun(@pdist,LowDMaps,'UniformOutput',0);
    LowDRDMs = cell2mat(LowDRDMs)';
    RDMCorrelations = corr(LowDRDMs,'rows','pairwise');
    RDMCorrelations = RDMCorrelations(tril(ones(nBootStraps))==0);
    
    ClustRDMs = cellfun(@pdist,ClustIdx,'UniformOutput',0);
    ClustRDMs = cell2mat(ClustRDMs)';
    ClustCorrelations = corr(ClustRDMs,'rows','pairwise');
    ClustCorrelations = ClustCorrelations(tril(ones(nBootStraps))==0);
    
    %%
    
    figure(1);
    hist(OptimalK,1:MaxClusts);
    axis('tight')
    xlabel('Optimal Number of Clusters');
    MyPrint(sprintf('%s_BootStrapResults_OptimalK.png',Pattern))
    
    
    figure(2)
    hist(RDMCorrelations,50);
    title('Similarity of Low Dimensional Representations(RDM Pearson Correlation)');
    MyPrint(sprintf('%s_BootStrapResults_RDMCorrelation.png',Pattern));
    
    figure(3)
    hist(ClustCorrelations,50);
    title('Similarity of Clusterings(RDM Pearson Correlation of Clustering matrices)');
    MyPrint(sprintf('%s_BootStrapResults_ClusteringSimilarity.png',Pattern));
    
    %%
    fname = sprintf('%s-bootstrapresults.mat',Pattern);
    save(fname,'SubIdx','ClustObj');    
end