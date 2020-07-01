function newEigenset = compressEigenvalues(eigenset, fromLB, fromUB, toVal)

   newEigenset = eigenset;
   for ii = 1:size(eigenset,1)
      for jj = 1:size(eigenset,2)
         if ((real(eigenset(ii,jj)) <= fromUB) && (real(eigenset(ii,jj)) >= fromLB))
            newEigenset(ii,jj) = toVal + 1i*imag(newEigenset(ii,jj));
         end
      end
   end
  
end