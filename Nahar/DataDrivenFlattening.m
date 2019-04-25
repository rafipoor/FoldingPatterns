clear;
close all;
load('SearchLightIdx');
load('HemisphereIdx.mat');

LIdx  = HemisphereIdx(HemisphereIdx(:,3) ==1,2)+1;
LObj  = gifti('S1200.L.inflated_MSMAll.32k_fs_LR.surf.gii');
LLocs = LObj.vertices;
InvalidVer = setxor(1:size(LLocs,1),LIdx);
LLocs(InvalidVer,:) = [];
LnVox = size(LIdx,1);

TwoDMap = DimensionReduction(LLocs,2,'Isomap');
scatter(TwoDMap(:,1),TwoDMap(:,2));