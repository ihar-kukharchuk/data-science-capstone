# data-science-capstone

project layout are based on the following articles:
* https://www.r-bloggers.com/structuring-r-projects/
* https://nicercode.github.io/blog/2013-04-05-projects/
* https://www.carlboettiger.info/2012/05/06/research-workflow.html

how to run all UTs?
source("tests/R/suites.R")

# The design of current project

The root directory for project has name $PROJECT_HOME.
There is a config file in $PROJECT_HOME/config.yml that determines external
configurations for project like URLs and structure.
The main analyses flow is described in $PROJECT_HOME/run-analyses.R that
determines the main steps of algorithms, also any additional configurations
should be added in Main() function there:
1. at the beginning add helper packages:
    * checkpoint - to stabilize versions of packages used in the project
    * pacman - to delegate manipulations with packages (such as check/load)
2. initiate main analyses workflow
