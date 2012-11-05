function data = readData(year)

   
    filename = sprintf('data/%s-pres-polls.csv',num2str(year));
    fid = fopen(filename);
    fmt = '%s %f %f %s %s';
    
    csv = textscan(fid,fmt,'headerlines',1,'delimiter',',');
    
    data.state    = csv{1};
    data.dem      = csv{2};
    data.gop      = csv{3};
    data.date     = csv{4};
    data.pollster = csv{5};
    
    %If using 2004 or 2008 data, replace abbreviations with full names
    if ismember(year,[2004 2008])
        abbreviations = loadAbbreviations;
        for ii = 1:length(data.state)
            abbr = data.state{ii};
            idx  = strmatch(abbr,abbreviations.abbr,'exact');
            data.state{ii} = abbreviations.state{idx};
        end
    end
    
    %Convert dates to numbers
    for ii = 1:length(data.date)
        date = [data.date{ii} ' ' num2str(year)];
        data.datenum(ii,:) = datenum(date);
    end

end