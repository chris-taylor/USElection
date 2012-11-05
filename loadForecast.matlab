function data = loadForecast(year)

    filename = sprintf('forecast/USElectionForecast%s.csv',num2str(year));
    fid = fopen(filename);
    fmt = '%s %s %f%%';
    
    csv = textscan(fid,fmt,'headerlines',1,'delimiter',',');
    
    data.state    = csv{1};
    data.result   = csv{2};
    data.conf     = csv{3};

end