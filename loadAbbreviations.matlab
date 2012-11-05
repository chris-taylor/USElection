function data = loadAbbreviations()

    fid = fopen('data/state-abbreviations.csv');
    
    csv = textscan(fid,'%s %s','delimiter',',');
    
    fclose(fid);
    
    data.state = csv{1};
    data.abbr  = csv{2};

end