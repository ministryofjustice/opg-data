DROP table IF EXISTS deputy_reporting_checklist_query;

-- Create a table to hold the results
CREATE TABLE deputy_reporting_checklist_query (
    id INT NOT NULL,
    uuid uuid,
    friendlydescription varchar(255),
    caserecnumber varchar(255),
    report_submitted_date date,
    report_end_year varchar(20),
    type varchar(30),
    createdby_email varchar(255),
    replacedby_id int,
    PRIMARY KEY(id)
);


-- Populate table with documents type = 'Report - Checklist'
-- (2351 rows on preproduction @ 45 seconds)
INSERT INTO deputy_reporting_checklist_query (
    SELECT d.id,
           d.uuid,
           d.friendlydescription,
          p.caserecnumber,
           NULL,
           NULL,
           d.type,
           a1.email,
           d.replacedby_id
    FROM documents d
             LEFT JOIN person_document pd
                       ON d.id = pd.document_id
             LEFT JOIN persons p
                       ON p.id = pd.person_id
             LEFT JOIN assignees a1
                       ON a1.id = d.createdby_id
    WHERE d.type = 'Report - Checklist'
)
ON CONFLICT DO NOTHING;

-- Populate table with documents type = 'Report' | 'Report - General' filename contains '%hecklist%'
-- (62171 rows on preproduction @ 66seconds)
INSERT INTO deputy_reporting_checklist_query (
    SELECT d.id,
           d.uuid,
           d.friendlydescription,
          p.caserecnumber,
           NULL,
           NULL,
           d.type,
           a1.email,
           d.replacedby_id
    FROM documents d
             LEFT JOIN person_document pd
                       ON d.id = pd.document_id
             LEFT JOIN persons p
                       ON p.id = pd.person_id
             LEFT JOIN assignees a1
                       ON a1.id = d.createdby_id
    WHERE d.type IN ('Report','Report - General')
    AND direction = 2
    AND documentsource = 'UPLOAD'
    AND d.friendlydescription LIKE '%hecklist%'
)
ON CONFLICT DO NOTHING;



-- update table using regexes to determine end year and submit date from filename
UPDATE deputy_reporting_checklist_query SET report_submitted_date = NULL, report_end_year = NULL;

--2 digit years regex goes first
-- matches DigiChecklist-YYYY-YY_YYYY-MM-DD_CCCCCCCC.pdf
UPDATE deputy_reporting_checklist_query
SET
    report_submitted_date = CAST(substring(friendlydescription from 'DigiChecklist-\d{4}-\d{2}_(\d{4}-\d{2}-\d{2})_\d{7}[\d|T|t].pdf') AS date),
    report_end_year = substring(friendlydescription from 'DigiChecklist-\d{4}-(\d{2})_\d{4}-\d{2}-\d{2}_\d{7}[\d|T|t].pdf')
WHERE report_submitted_date IS NULL AND report_end_year IS NULL
;

-- matches Lodging [Cc]hecklist YY-YY
UPDATE deputy_reporting_checklist_query
SET
    report_end_year = substring(friendlydescription from 'Lodging [Cc]hecklist\s\d{2}-(\d{2}).*')
WHERE report_submitted_date IS NULL AND report_end_year IS NULL
;

-- matches Lodging [Cc]hecklist YYYY-YY
UPDATE deputy_reporting_checklist_query
SET
    report_end_year = substring(friendlydescription from 'Lodging [Cc]hecklist\s\d{4}-(\d{2}).*')
WHERE report_submitted_date IS NULL AND report_end_year IS NULL
;

-- convert those 2 digit years to 4
UPDATE deputy_reporting_checklist_query SET report_end_year = CONCAT('20', report_end_year) WHERE report_end_year IS NOT NULL;


--now 4 digit years...
-- matches Lodging [Cc]hecklist YYYY-YYYY
UPDATE deputy_reporting_checklist_query
SET
    report_end_year = substring(friendlydescription from 'Lodging [Cc]hecklist\s\d{4}-(\d{4}).*')
WHERE report_submitted_date IS NULL AND report_end_year IS NULL
;

-- matches DigiChecklist-YYYY_YYYY-MM-DD_CCCCCCCC.pdf
UPDATE deputy_reporting_checklist_query
SET
    report_submitted_date = CAST(substring(friendlydescription from 'DigiChecklist-\d{4}_(\d{4}-\d{2}-\d{2})_\d{7}[\d|T|t].pdf') AS date),
    report_end_year = substring(friendlydescription from 'DigiChecklist-(\d{4})_\d{4}-\d{2}-\d{2}_\d{7}[\d|T|t].pdf')
WHERE report_submitted_date IS NULL AND report_end_year IS NULL
;

-- matches DigiChecklist-YYYY-YYYY_YYYY-MM-DD_CCCCCCCC.pdf
UPDATE deputy_reporting_checklist_query
SET
    report_submitted_date = CAST(substring(friendlydescription from 'DigiChecklist-\d{4}-\d{4}_(\d{4}-\d{2}-\d{2})_\d{7}[\d|T|t].pdf') AS date),
    report_end_year = substring(friendlydescription from 'DigiChecklist-\d{4}-(\d{4})_\d{4}-\d{2}-\d{2}_\d{7}[\d|T|t].pdf')
WHERE report_submitted_date IS NULL AND report_end_year IS NULL
;


-- Set an output csv file
\o digideps_uuid/output/digideps_checklist_update.sql;


-- Generate Digideps update sql script in digideps_uuid/output/digideps_checklist_update.sql;
SELECT CONCAT(
    'UPDATE checklist SET opg_uuid=''',
    subquery.uuid,
    ''' FROM (SELECT r.id FROM report r LEFT JOIN client c ON c.id = r.client_id WHERE c.case_number = ''',
    subquery.caserecnumber,
    ''' AND TO_CHAR(r.submit_date, ''YYYY-MM-DD'') = ''',
    subquery.report_submitted_date,
    ''' AND TO_CHAR(r.end_date, ''YYYY'') = ''',
    subquery.report_end_year,
    ''') AS report_subquery, (SELECT u.id FROM dd_user u WHERE u.email = ''',
    subquery.createdby_email,
    ''') AS user_subquery WHERE checklist.report_id=report_subquery.id AND checklist.submitted_by=user_subquery.id;'
) digideps_update_statement
FROM
(
    SELECT uuid,
           caserecnumber,
           report_submitted_date,
           report_end_year,
           createdby_email
    FROM deputy_reporting_checklist_query
    ORDER BY id DESC
) subquery
WHERE subquery.report_end_year IS NOT NULL
AND subquery.report_submitted_date IS NOT NULL;

-- Stop sending output
\o