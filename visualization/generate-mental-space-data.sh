#!/bin/bash
# Generate mental space data from actual repositories and workspaces
# Usage: ./generate-mental-space-data.sh > mental-space-data.json

set -euo pipefail

# Output JSON structure
echo "{"
echo '  "timestamp": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'",'
echo '  "agents": ['

# Shell of Nine agents
cat << 'EOF'
    {
      "id": "lumen",
      "name": "Lumen",
      "emoji": "✴️",
      "coord": "2.1.3/4.7.11/18.29.47",
      "machine": "lilly",
      "role": "Sales",
      "activity": 0
    },
    {
      "id": "phex",
      "name": "Phex",
      "emoji": "🔱",
      "coord": "1.5.2/3.7.3/9.1.1",
      "machine": "aurora-continuum",
      "role": "Engineering",
      "activity": 0
    },
    {
      "id": "cyon",
      "name": "Cyon",
      "emoji": "✎",
      "coord": "TBD",
      "machine": "halcyon-vector",
      "role": "Operations",
      "activity": 0
    },
    {
      "id": "lux",
      "name": "Lux",
      "emoji": "☼",
      "coord": "2.3.5/7.11.13/17.19.23",
      "machine": "logos-prime",
      "role": "Vision",
      "activity": 0
    },
    {
      "id": "chrys",
      "name": "Chrys",
      "emoji": "🦋",
      "coord": "1.1.2/3.5.8/13.21.34",
      "machine": "chrysalis-hub",
      "role": "Marketing",
      "activity": 0
    },
    {
      "id": "theia",
      "name": "Theia",
      "emoji": "🔭",
      "coord": "TBD",
      "machine": "aletheia-core",
      "role": "Onboarding",
      "activity": 0
    },
    {
      "id": "verse",
      "name": "Verse",
      "emoji": "🌀",
      "coord": "3.1.4/1.5.9/2.6.5",
      "machine": "AWS",
      "role": "Infra",
      "activity": 0
    },
    {
      "id": "litmus",
      "name": "Litmus",
      "emoji": "🧪",
      "coord": "TBD",
      "machine": "TBD",
      "role": "QA",
      "activity": 0
    },
    {
      "id": "flux",
      "name": "Flux",
      "emoji": "⚡",
      "coord": "TBD",
      "machine": "splinter",
      "role": "R&D",
      "activity": 0
    }
EOF

echo '  ],'
echo '  "repos": ['

# Scan /source for git repositories
first_repo=true
for repo_path in /source/*; do
  if [ -d "$repo_path/.git" ]; then
    repo_name=$(basename "$repo_path")
    
    # Get last commit timestamp
    last_commit=$(cd "$repo_path" && git log -1 --format=%ct 2>/dev/null || echo "0")
    current_time=$(date +%s)
    age_days=$(( (current_time - last_commit) / 86400 ))
    
    # Calculate activity score (decays with age)
    if [ $age_days -lt 1 ]; then
      activity=1.0
    elif [ $age_days -lt 7 ]; then
      activity=0.8
    elif [ $age_days -lt 30 ]; then
      activity=0.5
    else
      activity=0.2
    fi
    
    # Get file count
    file_count=$(cd "$repo_path" && git ls-files | wc -l)
    
    if [ "$first_repo" = false ]; then
      echo ","
    fi
    first_repo=false
    
    cat << EOF
    {
      "id": "$repo_name",
      "name": "$repo_name",
      "path": "$repo_path",
      "files": $file_count,
      "lastCommit": $last_commit,
      "ageDays": $age_days,
      "activity": $activity
    }
EOF
  fi
done

echo ''
echo '  ],'
echo '  "rallies": ['

# Scan for rally directories in exo-plan
first_rally=true
if [ -d "/source/exo-plan/rally" ]; then
  for rally_path in /source/exo-plan/rally/R*; do
    if [ -d "$rally_path" ]; then
      rally_name=$(basename "$rally_path")
      
      # Count markdown files as activity indicator
      md_count=$(find "$rally_path" -name "*.md" -type f | wc -l)
      
      # Check for recent modifications (last 7 days)
      recent_files=$(find "$rally_path" -type f -mtime -7 | wc -l)
      
      if [ $recent_files -gt 0 ]; then
        status="active"
        activity=1.0
      else
        status="complete"
        activity=0.5
      fi
      
      if [ "$first_rally" = false ]; then
        echo ","
      fi
      first_rally=false
      
      cat << EOF
      {
        "id": "$(echo $rally_name | tr '[:upper:]' '[:lower:]')",
        "name": "$rally_name",
        "path": "$rally_path",
        "files": $md_count,
        "status": "$status",
        "activity": $activity
      }
EOF
    fi
  done
fi

echo ''
echo '  ],'
echo '  "workspaces": ['

# Key workspace directories
cat << 'EOF'
    {
      "id": "openclaw-workspace",
      "name": "~/.openclaw/workspace",
      "path": "/home/wbic16/.openclaw/workspace",
      "machine": "lilly",
      "activity": 1.0
    },
    {
      "id": "source",
      "name": "/source",
      "path": "/source",
      "machine": "lilly",
      "activity": 0.9
    }
EOF

echo '  ],'
echo '  "connections": ['

# Generate connections from git log data
# This is a simplified version - real implementation would parse git logs for author/file relationships

cat << 'EOF'
    { "source": "lumen", "target": "r23", "strength": 1.0, "type": "leads", "recent": true },
    { "source": "lumen", "target": "vtpu", "strength": 1.0, "type": "works-on", "recent": true },
    { "source": "lumen", "target": "openclaw-workspace", "strength": 0.9, "type": "uses", "recent": true },
    { "source": "r23", "target": "vtpu", "strength": 1.0, "type": "produces", "recent": true },
    { "source": "phex", "target": "sq", "strength": 0.9, "type": "maintains", "recent": false },
    { "source": "chrys", "target": "r22", "strength": 0.8, "type": "led", "recent": false },
    { "source": "chrys", "target": "phext-dot-io-v2", "strength": 0.9, "type": "works-on", "recent": false },
    { "source": "verse", "target": "phext-dot-io-v2", "strength": 0.9, "type": "deploys", "recent": true },
    { "source": "vtpu", "target": "exo-plan", "strength": 0.8, "type": "documented-in", "recent": true }
EOF

echo ''
echo '  ]'
echo "}"
