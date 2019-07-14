String githubUserCredentialId = "github"

String projectOwner = "gvirtuoso"
String projectName = "docker-sample-nginx"

String jobPipelineName = new StringBuilder()
    .append("pipeline")
    .append("_")
    .append(projectName)
    .toString()

String jobPipelineDisplayName = new StringBuilder()
    .append("Pipeline")
    .append(" - ")
    .append(projectOwner)
    .append("/")
    .append(projectName)
    .toString()

String jobPipelineDescription = new StringBuilder()
    .append("Multibranch Pipeline for ")
    .append(projectOwner)
    .append("/")
    .append(projectName)
    .toString()

multibranchPipelineJob(jobPipelineName) {
    displayName(jobPipelineDisplayName)
    description(jobPipelineDescription)
    configure { node ->
        node / sources(class: 'jenkins.branch.MultiBranchProject$BranchSourceList') / data / 'jenkins.branch.BranchSource' / source(class: 'org.jenkinsci.plugins.github_branch_source.GitHubSCMSource') {
            id jobPipelineName
            credentialsId githubUserCredentialId
            repoOwner projectOwner
            repository projectName
            traits {
                'org.jenkinsci.plugins.github__branch__source.BranchDiscoveryTrait'() {
                    strategyId '3'
                }
                'org.jenkinsci.plugins.github__branch__source.OriginPullRequestDiscoveryTrait'() {
                    strategyId '1'
                }
                'org.jenkinsci.plugins.github__branch__source.TagDiscoveryTrait'()
                'jenkins.plugins.git.traits.CleanAfterCheckoutTrait'() {
                    extension(class: 'hudson.plugins.git.extensions.impl.CleanCheckout')
                }
                'jenkins.plugins.git.traits.CleanBeforeCheckoutTrait'() {
                    extension(class: 'hudson.plugins.git.extensions.impl.CleanBeforeCheckout')
                }
                'jenkins.plugins.git.traits.PruneStaleBranchTrait'() {
                    extension(class: 'hudson.plugins.git.extensions.impl.PruneStaleBranch')
                }
            }
        }
    }
    orphanedItemStrategy {
        discardOldItems {
            daysToKeep(-1)
            numToKeep(-1)
        }
    }
    triggers {
        periodicFolderTrigger {
            interval("30")
        }
    }
}
