function [ OoSE_emb ] = nn_OoSE_run(trainingCellShapeData, DIST, new_unique_savedestination,K )

fprintf('Using K=3\n',K)
h = waitbar(0,'Please wait...');
waitbar(0,h,sprintf('%5.2f%% completed ..',0));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
train_nobsX=length(trainingCellShapeData.point);
X=[];%zeros(train_nobs,2);
Y=[];%zeros(N,2);
for i=1:train_nobsX
    X=[X; trainingCellShapeData.point(i).SCORE(1) trainingCellShapeData.point(i).SCORE(2) trainingCellShapeData.point(i).SCORE(3) trainingCellShapeData.point(i).SCORE(4) trainingCellShapeData.point(i).SCORE(5)];
end
%DIST


[MinDIST, MinDISTindex] = sort(double(DIST.D));

OoSE_emb=[];
MININDEX=MinDISTindex(1:K,:);
[~, r]=size(MININDEX);
%first find the first nearest neighbors
%second normalize each row to have sum of 1 and 
%A=[1 2 0; 2 1 1;3 1 2];
%mean(A)
%   2.0000    1.3333    1.0000
%w=[1/2 1 1/2;1/2 0 1/2;0 0  0];
%y=sum(w.*A)./sum(w);
%   1.5000    2.0000    0.5000

for i=1:r
    %size(MININDEX(:,i))
    %mean(X(MININDEX(:,i),:))
    OoSE_emb=[OoSE_emb ;mean(X(MININDEX(:,i),:))];
  
end
 save([new_unique_savedestination '/OoSE_embedding.mat'], 'OoSE_emb','-v7.3');
 h=waitbar(1,h,'Complete');
 delete(h);

end

