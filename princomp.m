function [coeff,score,latent] = princomp(X)

B = X- repmat(mean(X),size(X,1),1);
C = cov(B)
[V,D] = eig(C);
[s,index] = sort(diag(D),'descend');
coeff = V(:,index);
sum_s = sum(s)
latent = s / sum_s * 100;
score = B * coeff;
