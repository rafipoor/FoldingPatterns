clear;
close all;
load('SearchLightResults2.mat');
load('SearchLightIdx');
load('HemisphereIdx.mat');
%%
LIdx  = HemisphereIdx(HemisphereIdx(:,3) ==1,2)+1;
LObj  = gifti('S1200.L.inflated_MSMAll.32k_fs_LR.surf.gii');
LLocs = LObj.vertices;
InvalidVer = setxor(1:size(LLocs,1),LIdx);
LLocs(InvalidVer,:) = [];
LnVox = size(LIdx,1);

Map = LeftMaps(:,5);
hist(Map,100);
Anomalies = Map ~= mode(Map);
AnomLocs = LLocs(Anomalies,:);
cla;
hold on; 
scatter3(LLocs(:,1),LLocs(:,2),LLocs(:,3),[],'b','filled');
scatter3(AnomLocs(:,1),AnomLocs(:,2),AnomLocs(:,3),[],'r','filled');
view(90,0);
axis('off')
MyPrint('Anomalies24.png');