function data = loadElectoralVotes()

    fid = fopen('data/electoral-college-votes.csv');
    
    csv = textscan(fid,'%s %d','delimiter',',');
    
    fclose(fid);
    
    data.state = csv{1};
    data.ev    = csv{2};

end