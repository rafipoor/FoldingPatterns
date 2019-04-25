close all
clear
Patterns = {'Thickness','Curvature','Sulc'};
DrMethod  = 'isomap';

%%
for pi = 1:numel(Patterns)
    Pattern     = Patterns{pi};
    load(sprintf('all%s_S1200_1096_MSMAll_cdata.mat',Pattern));
    eval(sprintf('Data = transpose(all%s_MSMAll_cdata);',Pattern));
    %% Dimensionality Reduction
    Y = DimensionReduction(Data,2,DrMethod);
    eval(sprintf('%s = Y;',Pattern));
    %% Visualize
    figure;
    scatter(Y(:,1),Y(:,2),'filled');
    xlabel('Dimension 1'); ylabel('Dimension 2');
    title(sprintf('%s-%s',DrMethod,Pattern));
    axis('square')
end

save('AllLowDPatterns',Patterns{1},Patterns{2},Patterns{3});