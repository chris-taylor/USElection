function data = loadResults(year)
   
    filename = sprintf('data/%s-results.csv',num2str(year));
    fid = fopen(filename);
    fmt = '%s %f %f %s';
    
    csv = textscan(fid,fmt,'headerlines',1,'delimiter',',');
    
    data.state    = csv{1};
    data.dem      = csv{2};
    data.gop      = csv{3};
    data.result   = csv{4};
    
end