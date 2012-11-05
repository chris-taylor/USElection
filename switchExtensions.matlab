function switchExtensions(from,to)
%SWITCHEXTENSIONS Rename all files with the extension 'from' to have
%extension 'to'.

    contents = dir();
    
    for ii = 1:length(contents)
       
        [directory filename extension] = fileparts(contents(ii).name);
        
        if strcmp(extension,from)
            old_name = [filename from];
            new_name = [filename to];
            movefile(old_name,new_name);
        end
        
    end

end