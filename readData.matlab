function data = readData

    filename = 'pres_polls.csv';
    
    fid = fopen(filename);
    fmt = '%f %f %s %f %f %f %s %s';
    
    csv = textscan(fid,fmt,'headerlines',1,'delimiter',',');
    
    data.day = csv{1};
    data.len = csv{2};
    data.state = csv{3};
    data.ev = csv{4};
    data.dem = csv{5};
    data.gop = csv{6};
    data.date = csv{7};
    data.pollster = csv{8};

end