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
* Fork and clone `git@github.com:<your-fork-name>/concourse-training-scripts.git` - this repo
* `git@github.com:cf-pub-tools/small-book.git` - an example book
* `git@github.com:cf-pub-tools/tiny-section.git` - an accompanying section
* `git@github.com:cf-pub-tools/bookbinder-ci-credentials` - creds for the pubtools env (at your own risk!)

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

5. Start up Concourse!

You're ready to start running a pipeline! 

* `cd` out of `concourse`
* `vagrant init concourse/lite` to get the basic Concourse Vagrant image
* `vagrant up` to start Concourse
* Your server will be running at [192.168.100.4:8080](192.168.100.4:8080)

* Navigate to the above URL 
* Download the Fly CLI from the link on the page and add it your PATH

6. Configure Concourse to use your setup

* `fly configure -c pipelines/my-pipeline.yml`

7. Add additional config

- private keys
- trigger: true
- passed: [job]
- resource: [different-resource-version]
- privileged: true/false






