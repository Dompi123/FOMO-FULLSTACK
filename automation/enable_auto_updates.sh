#!/bin/bash

# Auto-deploy when quality checks pass
set -eo pipefail

./cursor-agent --ci-check && \

fastlane deploy_appstore && \

fastlane deploy_playstore && \

gh workflow run deploy-web.yml

