#Doing the Concourses

After this exercise, the goal is for you to be able to:

* Understand whether to place a command in a pipeline.yml, task.yml, or task.sh
* Understand the interactions between the pipeline and the tasks
* Understand how to access the Concourse UI
* Understand how to use the Fly CLI to run one-off builds
* Understand specific Concourse keys:
  - trigger
  - passed
  - resource

1. Get your repos

    `mkdir concourse && cd concourse`

    Fork this repo and clone sample materials:
    * Fork and clone `git@github.com:<your-fork-name>/concourse-training-scripts.git concourse-scripts` - this repo
    * `git@github.com:cf-pub-tools/small-book.git book` - an example book
    * `git@github.com:cf-pub-tools/tiny-section.git` - an accompanying section
    * `git@github.com:cf-pub-tools/bookbinder-ci-credentials credentials` - creds for the pubtools env (at your own risk!)

2. Make a pipeline.yml

    This is where all your resources (GoCD 'materials'), jobs (GoCD 'stages' and 'tasks'), and scripts (same in GoCD) are configured.

    * `cd concourse-training-scripts`
    * Open `pipelines/my-pipeline.yml`
    * Fill in the keys for tiny-section and credentials. We can answer any questions. Small-book is already completed as an example.

3. Create your first Concourse Job

    * Open `pipelines/my-pipeline.yml`
    * Under `plan:` for the `staging` job, fill in the resources required for the Job. 
        - You specify a resource to fetch using the `get: <resource-name>` key.
    * Enter in the `task:` name
    * Enter the relative path to the task YAML file, starting from this directory: `concourse-training-scripts/<your-task-name>.yml`

4. Create your first Concourse Task file

    * Open `publish-to-staging.yml` 
    * Enter the inputs to your Task. These will be things like your book, sections, and credentials (your resources).
        - They should directly correspond to the resources you listed for your Job in my-pipeline.yml.
    * Enter the relative path to the script the task should run, starting from this directory: `concourse-training-scripts/<your-task-name>.sh`
        - We have created this script for you.

5. Add a Private Key
    
    * We'll require a ssh key to download the resources from Github.
    * Open `pipelines/my-pipeline.yml`
    * For the `small-book` resource under the `source` key, you'll see that `private-key` is specified as `{{private-key}}`. This is Concourse's syntax for inserting variables - useful for keeping your private key out of your committed manifest.
        - We will pass this key into Concourse in Step 7

6. Running as Root

    Concourse requires that you run stages as root. Do this by adding `privileged: true` in each of your jobs.

7. Start up Concourse!

    You're ready to start running a pipeline! 

    * `cd` out of `concourse-training-scripts` and into `concourse`
    * `vagrant init concourse/lite` to get the basic Concourse Vagrant image
    * `vagrant up` to start Concourse
    * Your server will be running at [192.168.100.4:8080](192.168.100.4:8080)

    * Navigate to the above URL 
    * Download the Fly CLI from the link on the page and add it your PATH

8. Configure Concourse to use your setup
    
    * We tell Concourse what file to display with `fly configure`
    * We also need to tell it what `private-key` to insert

    * From the top-level `concourse` folder:
        - `fly configure -c pipelines/my-pipeline.yml --var "private-key=$(cat credentials/git_ssh_key)"`
    * Check [192.168.100.4:8080](192.168.100.4:8080)!

9. Add Concourse-specific configuration

    A. Triggering Jobs when Resources get Updated
        
        * As of version 0.51.0, Concourse does NOT automatically trigger builds when a Resource is updated
        * This means, when you want a Job to kick off when a Resource is updated, we will add a specific key to its `job:`

        ```
        jobs:
          - name: staging
            plan: 
              - get: book
                trigger: true
            ...
        ```

    B. Triggering Jobs when a Job finishes

      * To set a stage to automatically trigger when the preceding stage has successfully completed, you need to pass the resources from the preceding stage to the next one.
      * To do this, add a `passed` key to each resource in the stage you want to trigger:

      ```
      jobs:
       - name: staging
         plan: 
           - get: book
             trigger: true
            ...

      jobs:
      - name: production
        plan:
        - aggregate:
          - get: book
            passed: [staging]
          ...
      ```
    C. Changing which Resource to use as 'Book' or 'Credentials'

      * You can choose to use a specific version of a resource, like a book, by specifying a `resource` key:

      ```
      - name: staging
        plan:
          - get: concourse-scripts
            trigger: true
          - get: book
            resource: different-book
            trigger: true
      ``` 

      * This is useful, because your task.yml expects the resource (under `input:`) to be named a specific thing:

      ``` 
      # pipeline.yml
      
      - name: staging
        plan:
          - get: concourse-scripts
            trigger: true
          - get: book
            resource: different-book
            trigger: true
          - task: publish-to-staging
            file: concourse-scripts/publish-to-staging.yml
      ```

      ```
      # task.yml

      inputs: 
        - name: book        # this now refers to 'different-book'
        - name: tiny-section
        - name: credentials
      ```

10. Running One-Off Builds

   * To run a single task (as opposed to an entire pipeline) as a one-off build, you can use `fly -c <task>.yml`.

   * If the task has `input`s, fly will ask you to submit those. Do so using `-i <input-name>=<path-to-resource>`
   
   ```
   fly -c concourse-scripts/publish-to-staging.yml -i book=./book -i tiny-section=./tiny-section -i credentials=./credentials
   ```




