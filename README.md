# VIVIDUS Sample Tests

The purpose of this repository is to demo VIVIDUS capabilities via sample tests.

The instructions on how to run tests can be found in the official ["Getting Started"](https://docs.vividus.dev/vividus/latest/getting-started.html) guide.

## List of the available samples

By default the project is not configured to run any test suite: an attempt to execute tests without prior configuration will lead to an error.

### Local test execution
| Test Suite            | Command |
|-----------------------|---------|
| REST API tests        | macOS/Linux:<br/><pre>./gradlew runStories -Pvividus.configuration.suites=rest_api</pre><br/>Windows:<br/><pre>gradlew runStories -Pvividus.configuration.suites=rest_api</pre> |
||
| Web Application tests | macOS/Linux:<br/><pre>./gradlew runStories -Pvividus.configuration.suites=web_app -Pvividus.configuration.profiles=web/desktop/chrome</pre><br/>Windows:<br/><pre>gradlew runStories -Pvividus.configuration.suites=web_app -Pvividus.configuration.profiles=web/desktop/chrome</pre> |

### Test execution in CI

|CI            |Configuration sample                                                                                              |Test execution based on sample configuration                                                             |
|--------------|------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------|
|GitHub Actions|<ul><li>[test-run.yml](https://github.com/vividus-framework/vividus-sample-tests/blob/main/.github/workflows/test-run.yml)</li> <li>[mobile-test-run.yml](https://github.com/vividus-framework/vividus-sample-tests/blob/main/.github/workflows/mobile-test-run.yml)</li> <li>[electron-test-run.yml](https://github.com/vividus-framework/vividus-sample-tests/blob/main/.github/workflows/mobile-test-run.yml)</li></ul>|<ul><li>[Workflow runs](https://github.com/vividus-framework/vividus-sample-tests/actions/workflows/test-run.yml)</li> <li>[Mobile Workflow runs](https://github.com/vividus-framework/vividus-sample-tests/actions/workflows/mobile-test-run.yml)</li> <li>[Electron Workflow runs](https://github.com/vividus-framework/vividus-sample-tests/actions/workflows/electron-tests.yml)</li></ul>|
|GitLab CI     |[.gitlab-ci.yml](https://github.com/vividus-framework/vividus-sample-tests/blob/main/.gitlab-ci.yml)              |[Pipeline runs](https://gitlab.com/vividus/vividus-sample-tests/-/pipelines)                             |
| Azure DevOps |[azure-pipelines.yml](https://github.com/vividus-framework/vividus-sample-tests/blob/main/azure-pipelines.yml)|[Pipeline runs](https://dev.azure.com/vividus/vividus-sample-tests/_build)|

## Still have questions?
:postbox: [Contact Us](https://docs.vividus.dev/vividus/latest/index.html#_contract_us)

## Personal notes
###Validate JSON field types (instead of exact value)

```
Then JSON element from `${response}` by JSON path `$` is equal to `
{
    "id": "${json-unit.any-number}",
    "name": "Test user",
    "email": "${randomemail}",
    "gender": "female",
    "status": "active"
}
`IGNORING_EXTRA_FIELDS
```

Available types:

```
"${json-unit.any-string}"
"${json-unit.any-boolean}"
"${json-unit.any-number}"
```
### Lifecycles simulationg beforeall, beforetest etc
[https://jbehave.org/reference/stable/lifecycle.html](https://jbehave.org/reference/stable/lifecycle.html)

### When build fails with 401 Unauthorized
[https://github.com/vividus-framework/vividus-build-system#update-from-the-vividus-build-system-remote](https://github.com/vividus-framework/vividus-build-system#update-from-the-vividus-build-system-remote)

```
git submodule update --remote vividus-build-system
```


### To raise tickets for the development team
https://github.com/vividus-framework/vividus/issues
