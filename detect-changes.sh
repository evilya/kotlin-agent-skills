# 1. Mock the GitHub Outputs file
export GITHUB_OUTPUT="./mock_output.txt"
touch $GITHUB_OUTPUT

# 2. Mock the inputs (Change these to your real SHAs or branch names)
export HEAD="699e6b3ac8a7e4434a08c8efbdab925c47870d16"
export BASE="445594d0a71e96f111932ea6191189bbc8f71a7e"

# 3. Run your detect-changes logic
SKILLS=$(git diff --name-only $BASE $HEAD | \
  grep 'SKILL.md$' | \
  xargs -I {} dirname {} | \
  sort -u | \
  jq -R -s -c 'split("\n") | map(select(length > 0))')

echo "Detected Skills: $SKILLS"

# 4. Mock the Matrix loop
for skill in $(echo $SKILLS | jq -r '.[]'); do
  echo "--- Validating: $skill ---"
  
  SKILL_DIR=$(basename $skill)
  
  # Paste your regex and grep logic here to see if it exits 1
  if [[ ! $SKILL_DIR =~ ^kotlin-([a-z0-9]+)-([a-z0-9-]+)$ ]]; then
    echo "Error: Skill directory name '$SKILL_DIR' is invalid"
  else
    echo "Success: $SKILL_DIR is valid"
  fi
done