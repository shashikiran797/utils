pwd=$(pwd)
cd /Users/shashikiranms/projects/vcbackend-2/src/e2e-test
find . -name \*.e2e-spec.ts -print
cd $pwd
node scripts/e2e.js 