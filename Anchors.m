function anchors=Anchors(X,m)
    maxIter = 100;
    numRep = 10;
    [~,anchors]=litekmeans(X,m,'MaxIter',maxIter,'Replicates',numRep); 
end
