function nbytes = stringExport(filename, str)

   fileID = fopen(filename,'w');
   nbytes = fprintf(fileID,'%s\n',str);
   fclose(fileID);
   
end
