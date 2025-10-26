% --- Step 1: Set up file path ---
% Assuming 'dati_time_series' is a subfolder in your current path
folderName = 'dati_time_series';
fileName = '2020_01_EnergyPrices_12.1.D_r3.csv';
filePath = fullfile(folderName, fileName);

% Check if the file exists
if ~isfile(filePath)
    error('File not found: %s\nPlease ensure the file is in the correct folder.', filePath);
end

% --- Step 2: Load the Data ---
% Set import options, specifying tab as the delimiter
opts = detectImportOptions(filePath, 'FileType', 'text');
opts.Delimiter = '\t'; % Specify tab delimiter

% Read the table
try
    dataTable = readtable(filePath, opts);
catch ME
    error('Error reading the file. Check if it is a valid tab-delimited CSV.\nOriginal error: %s', ME.message);
end

% --- Step 3: Inspect the Data ---
fprintf('Data loaded successfully. Here are the first few rows and column names:\n');
disp('Column Names:');
disp(dataTable.Properties.VariableNames); % Display column names
fprintf('\nFirst 5 rows:\n');
disp(head(dataTable, 5)); % Display the first 5 rows

% --- IMPORTANT: Stop and Identify Columns ---
% Based on the output above, identify the exact names of the columns for:
% 1. Time/Date information
% 2. Country information
% 3. The numeric value(s) you want to aggregate (e.g., 'Price', 'Quantity')

% --- Step 4: Preprocessing (Example - modify based on your column names) ---
% Replace 'YourTimeColumnName' with the actual name from Step 3
% Replace 'YourCountryColumnName' with the actual name from Step 3
% Replace 'YourValueColumnName' with the actual name from Step 3

% Example: Convert time column (assuming it's text) to datetime objects
% You might need to specify the input format if it's not standard
% timeColName = 'YourTimeColumnName';
% if iscell(dataTable.(timeColName)) || isstring(dataTable.(timeColName))
%     % Try common formats, adjust 'InputFormat' as needed
%     try
%         dataTable.(timeColName) = datetime(dataTable.(timeColName), 'InputFormat', 'yyyy-MM-dd HH:mm:ss'); % Adjust format!
%     catch
%         warning('Could not automatically convert time column. Please specify the correct InputFormat.');
%     end
% elseif isnumeric(dataTable.(timeColName))
%      % Handle numeric time if necessary (e.g., Excel date numbers)
%      % dataTable.(timeColName) = datetime(dataTable.(timeColName), 'ConvertFrom', 'excel');
% end


% Example: Ensure country column is categorical for grouping
% countryColName = 'YourCountryColumnName';
% dataTable.(countryColName) = categorical(dataTable.(countryColName));

% --- Step 5: Aggregation (Example - modify based on your needs) ---
% This example aggregates 'YourValueColumnName' by 'YourTimeColumnName' (grouped by day)
% and 'YourCountryColumnName', calculating the mean.

% valueColName = 'YourValueColumnName';

% --- Option A: Group by Country and Time Period (e.g., Daily Mean per Country) ---
% if exist('timeColName', 'var') && exist('countryColName', 'var') && exist('valueColName', 'var') && isdatetime(dataTable.(timeColName))
%     fprintf('\nAttempting aggregation...\n');
%     % Add a column for the date part only if you want daily aggregation
%     dataTable.DateOnly = dateshift(dataTable.(timeColName), 'start', 'day');
%
%     % Aggregate using groupsummary
%     aggregatedData = groupsummary(dataTable, {countryColName, 'DateOnly'}, 'mean', valueColName);
%
%     fprintf('Aggregation complete. Result:\n');
%     disp(head(aggregatedData, 10));
% else
%     fprintf('\nCannot proceed with aggregation yet. Please modify Steps 4 and 5 with your actual column names.\n');
% end

% --- Option B: Using retime for Timetables (if applicable) ---
% If your time column is the first column and unique/sorted, convert to timetable
% try
%     timetableData = table2timetable(dataTable, 'RowTimes', timeColName);
%     % Resample to daily mean, per country requires different approach or loop
%     dailyMean = retime(timetableData, 'daily', 'mean');
%     disp('Retimed to daily mean:');
%     disp(head(dailyMean));
% catch
%     warning('Could not convert to timetable easily. Use groupsummary (Option A).');
% end

% --- Step 6: Save or Use Aggregated Data (Optional) ---
% if exist('aggregatedData', 'var')
%     outputFileName = 'aggregated_energy_prices.csv';
%     writetable(aggregatedData, fullfile(folderName, outputFileName));
%     fprintf('Aggregated data saved to %s\n', fullfile(folderName, outputFileName));
% end

fprintf('\nScript finished. Please review the output and modify Steps 4 and 5.\n');