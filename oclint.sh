#!/bin/bash
# mark sure you had install the oclint and xcpretty

# You need to replace these values with your own project configuration
workspace_name="WorkSpaceName.xcworkspace"
scheme_name="SchemeName"

# clean project
# -sdk iphonesimulator means run simulator
xcodebuild -workspace $workspace_name -scheme $scheme_name -configuration Debug -sdk iphonesimulator clean || (echo "command failed"; exit 1);

# export compile_commands.json
xcodebuild -workspace $workspace_name -scheme $scheme_name -configuration Debug -sdk iphonesimulator \
| xcpretty -r json-compilation-database -o compile_commands.json \
|| (echo "command failed"; exit 1);

# export report html
# you can run `oclint -help` to see all USAGE
oclint-json-compilation-database -e Pods -- -report-type html -o oclintReport.html \
-disable-rule ShortVariableName \
-rc LONG_LINE=1000 \
-max-priority-1=9999 \
-max-priority-2=9999 \
-max-priority-3=9999 || (echo "command failed"; exit 1);

open -a "/Applications/Safari.app" oclintReport.html
