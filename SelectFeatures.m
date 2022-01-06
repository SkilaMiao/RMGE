function X1=SelectFeatures(X, k, seed)
    rng('default');  
    rng(seed);  
    
    [n,d]=size(X);
    a = randperm(d);   
    a = a(1:k);
    X1= X(:,a);
    
end