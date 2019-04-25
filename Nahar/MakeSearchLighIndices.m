clear;
close all;

nNeighbours   = 25;
nEUNeighbours = 3*nNeighbours;

load('HemisphereIdx.mat');


LIdx  = HemisphereIdx(HemisphereIdx(:,3) ==1,2)+1;
LObj  = gifti('S1200.L.inflated_MSMAll.32k_fs_LR.surf.gii');
LLocs = LObj.vertices;
InvalidVer = setxor(1:size(LLocs,1),LIdx);
LLocs(InvalidVer,:) = [];
LnVox = size(LIdx,1);
LSearchLightIdx = nan(LnVox,nNeighbours);

for i=1:LnVox
    Dists   = pdist2(LLocs,LLocs(i,:));
    [Dists,Globe] = sort(Dists);
    Globe    = Globe(1:nEUNeighbours);
    AllDists = squareform(pdist(LLocs(Globe,:)));
    
    Neighbours  = nan(nNeighbours,1);
    InsideDists = inf(nNeighbours,1);
    
    Neighbours(1)  = Globe(1);
    InsideDists(1) = 0;
    
    for k = 2:nNeighbours
        InsiderInd   = ismember(Globe,Neighbours(1:k-1));
        Outsiders    = Globe(InsiderInd==0);
        Dist2Neighbs = AllDists(InsiderInd==1,InsiderInd==0);
        Dist2Source  = bsxfun(@plus,Dist2Neighbs,InsideDists(1:k-1));
        [r,c] = find(Dist2Source == min(Dist2Source(:)),1);
        Neighbours(k)  = Outsiders(c);
        InsideDists(k) = min(Dist2Source(:));
    end
   LSearchLightIdx(i,:) = Neighbours;
end


RIdx = HemisphereIdx(HemisphereIdx(:,3) ==2,2)+1;
RObj  = gifti('S1200.R.inflated_MSMAll.32k_fs_LR.surf.gii');
RLocs = RObj.vertices;
InvalidVer = setxor(1:size(RLocs,1),RIdx);
RLocs(InvalidVer,:) = [];
RnVox = size(RIdx,1);
RSearchLightIdx = nan(RnVox,nNeighbours);

for i=1:RnVox
    Dists   = pdist2(RLocs,RLocs(i,:));
    [Dists,Globe] = sort(Dists);
    Globe    = Globe(1:nEUNeighbours);
    AllDists = squareform(pdist(RLocs(Globe,:)));
    
    Neighbours  = nan(nNeighbours,1);
    InsideDists = inf(nNeighbours,1);
    
    Neighbours(1)  = Globe(1);
    InsideDists(1) = 0;
    
    for k = 2:nNeighbours
        InsiderInd   = ismember(Globe,Neighbours(1:k-1));
        Outsiders    = Globe(InsiderInd==0);
        Dist2Neighbs = AllDists(InsiderInd==1,InsiderInd==0);
        Dist2Source  = bsxfun(@plus,Dist2Neighbs,InsideDists(1:k-1));
        [r,c] = find(Dist2Source == min(Dist2Source(:)),1);
        Neighbours(k)  = Outsiders(c);
        InsideDists(k) = min(Dist2Source(:));
    end
   RSearchLightIdx(i,:) = Neighbours;
end

save('SearchLightIdx100','LSearchLightIdx','RSearchLightIdx');
