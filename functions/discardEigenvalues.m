function newEigenset = discardEigenvalues(eigenset, fromLB, fromUB)

   newEigenset = {};
   for ii = 1:size(eigenset,1)
      num = 1;
      for jj = 1:size(eigenset,2)
         if ~(((real(eigenset(ii,jj)) <= fromUB) && (real(eigenset(ii,jj)) >= fromLB)))
            newEigenset{ii,num} = eigenset(ii,jj);
            num = num + 1;
         end
      end
   end
  
end