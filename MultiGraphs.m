function [G,F]=MultiGraphs(X,labels,label_index,kg,kf)

  n=size(X,1);
  k=length(unique(labels));  
  G=cell(kg,1);   
  F=zeros(n,k);
  parfor i=1:kg 
      fprintf('... ... the %dth graph computation ... ...\n', i);
      X1=SelectFeatures(X, kf, i);
      m = length(label_index);
      A= Anchors(X1,m);
      A=[A;X1(label_index,:)];
      s = 3;
      cn = 10;
      [Z,rL] = AnchorGraph(X1', A', s, 0, cn); 
      F1 = AnchorGraphOpt(Z, rL, labels', label_index, 0.01);
      G{i}=F1;
      F=F+F1;
  end
  F=F/kg;
end



