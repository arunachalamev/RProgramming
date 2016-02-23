# http://statr.me/2016/02/large-scale-eigen-and-svd-with-rarpack/

library(rARPACK)

set.seed(10)
# Random data
x = matrix(rnorm(1000*100),1000)

#If retvec == FALSE, we don't calculate eigenvectors
eigs_sym(cov(x), k =5, which ="LM", opts = list(retvec=FALSE))

library(Matrix)
spmat = as(cov(x),"dgCMatrix")
eigs_sym(spmat,2)

#SVDs
library (microbenchmark)
set.seed(10);
x = matrix(rnorm(2000*500),2000)
pc = function (x,k)
{
  ##Center the data
  xc = scale(x, center= TRUE, scale = FALSE)
  ## Partial SVD
  decomp = svds(xc,k,nu=0,nv=k)
  return(list(lodings = decomp$v, scores = xc %*% decomp$v))
}
microbenchmark(princomp(x),prcomp(x),pc(x,3), times=5)

