function master(year,window,method)

    if nargin < 1
        year = 2012;
    end
    
    if nargin < 2
        window = 30;
    end
    
    if nargin < 3
        method = 'median';
    end

    data   = readData(year);
    munged = mungeData(data,window,method);
    result = runModel(munged);
    
    fprintf('Results:\n')
    fprintf('  P(Dem win) = %6.2f%%\n',100*result.pDemWin)
    fprintf('  P(GOP win) = %6.2f%%\n',100*result.pGopWin)
    fprintf('  P(Tie)     = %6.2f%%\n',100*result.pTied)
    
    % Write output file
    fname = sprintf('forecast/USElectionForecast%s.csv',num2str(year));
    fid = fopen(fname,'w');
    
    fprintf(fid,'State,Winner,Confidence\n');
    
    for ii = 1:length(result.state)
        if result.pStateDem(ii) > 0.5
            party = 'DEM';
            conf  = 100 * result.pStateDem(ii);
        else
            party  = 'REP';
            conf   = 100 * result.pStateGop(ii);
        end
        
        fprintf(fid,'%s,%s,%.0f%%\n',result.state{ii},party,conf);
    end
    fclose(fid);
    
    % Plot a histogram of electoral college votes
    ev = loadElectoralVotes;
    totalEV = sum(ev.ev);
    
    hist(result.demVotes,20);
    ylimits = ylim;
    hold on
    plot([totalEV totalEV]/2, ylimits, 'r');
    hold off
    
    
    xlabel('Total electoral college votes (DEM)')
    ylabel('Number of simulations')
    legend({'Electoral college votes','Required to win'})
    
    % If looking at 2004 or 2008 data, assess forecasts
    if ismember(year,[2004 2008])
        assessment = compareForecast(year);
        
        fprintf('Forecast performance:\n')
        fprintf('  %d / 51 correctly forecast\n',assessment.nCorrect);
        fprintf('Incorrect predictions:\n')
        for ii = 1:length(assessment.wrong)
            fprintf('  %s\n',assessment.wrong{ii})
        end
    end
    
end