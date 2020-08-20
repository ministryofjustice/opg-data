### Cancel redundant builds

The purpose of this script is to cancel previous running workflows on the same branch as the current workflow but to
avoid cancelling the following:

- Terraform running workflows (or whatever other jobs you wish to not auto cancel)
- Production jobs on the 'main' branch

You can control these two parameters through the args `terms_to_waitfor` and `prod_job_terms` respectively.

They check for the terms you enter against the names of the jobs. The `terms_to_waitfor` is any job that you wish to
wait for before cancelling the workflow. Whereas, for any job that matches the  `prod_job_terms`, the entire workflow is
ignored and won't be cancelled.

You can add the script to a separate stage or just early on in one of your initial existing stages if you want to
save on spinning up a new box and you have python installed.

You will need an API key installed on circle for the cancellation portion bit to work correctly.

Example:
1. Workflow A is running a terraform job on Branch Z.
2. You start Workflow B.
3. Workflow B runs the script and waits for Workflow A's terraform job to finish.
4. When finished, it waits for a new job to start.
5. It checks if this is also a terraform job.
6. If it is go to step 3.
7. If no terraform jobs are running but other jobs are, then cancel the workflows with running jobs on current branch.

It won't cancel your own workflow or workflows that are running jobs with certain terms you set like 'production'.
