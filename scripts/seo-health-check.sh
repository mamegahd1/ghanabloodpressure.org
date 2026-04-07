#!/bin/bash
# GHSI Website SEO Health Check
# Run monthly: bash scripts/seo-health-check.sh
# Or ask Claude Code: "Run the SEO health check"

echo "========================================="
echo "  GHSI SEO Health Check — $(date +%Y-%m-%d)"
echo "========================================="
echo ""

SITE="https://ghanabloodpressure.org"
PAGES=("/" "/approach/" "/pilot/" "/team/" "/research/" "/involved/" "/blog/")
PASS=0
WARN=0
FAIL=0

# 1. Check all pages return HTTP 200
echo "--- Page Status ---"
for page in "${PAGES[@]}"; do
  status=$(curl -s -o /dev/null -w "%{http_code}" "${SITE}${page}")
  if [ "$status" = "200" ]; then
    echo "  ✅ ${page} — 200 OK"
    ((PASS++))
  else
    echo "  ❌ ${page} — HTTP ${status}"
    ((FAIL++))
  fi
done
echo ""

# 2. Check each page has a <title> tag
echo "--- Title Tags ---"
for page in "${PAGES[@]}"; do
  title=$(curl -s "${SITE}${page}" | grep -oE '<title>[^<]+</title>' | head -1)
  if [ -n "$title" ]; then
    echo "  ✅ ${page} — ${title}"
    ((PASS++))
  else
    echo "  ❌ ${page} — NO TITLE TAG FOUND"
    ((FAIL++))
  fi
done
echo ""

# 3. Check each page has a meta description
echo "--- Meta Descriptions ---"
for page in "${PAGES[@]}"; do
  desc=$(curl -s "${SITE}${page}" | grep -i 'meta name="description"' | head -1)
  if [ -n "$desc" ]; then
    echo "  ✅ ${page} — meta description present"
    ((PASS++))
  else
    echo "  ❌ ${page} — NO META DESCRIPTION"
    ((FAIL++))
  fi
done
echo ""

# 4. Check homepage has JSON-LD schema
echo "--- Schema Markup (Homepage) ---"
schema=$(curl -s "${SITE}/" | grep -c 'application/ld+json')
if [ "$schema" -gt 0 ]; then
  echo "  ✅ Homepage has ${schema} JSON-LD block(s)"
  ((PASS++))
else
  echo "  ❌ Homepage — NO JSON-LD SCHEMA FOUND"
  ((FAIL++))
fi
echo ""

# 5. Check sitemap.xml
echo "--- Sitemap ---"
sitemap_status=$(curl -s -o /dev/null -w "%{http_code}" "${SITE}/sitemap.xml")
if [ "$sitemap_status" = "200" ]; then
  url_count=$(curl -s "${SITE}/sitemap.xml" | grep -c '<loc>')
  echo "  ✅ sitemap.xml — 200 OK (${url_count} URLs)"
  ((PASS++))
else
  echo "  ❌ sitemap.xml — HTTP ${sitemap_status}"
  ((FAIL++))
fi
echo ""

# 6. Check robots.txt
echo "--- Robots.txt ---"
robots_status=$(curl -s -o /dev/null -w "%{http_code}" "${SITE}/robots.txt")
if [ "$robots_status" = "200" ]; then
  echo "  ✅ robots.txt — 200 OK"
  ((PASS++))
else
  echo "  ❌ robots.txt — HTTP ${robots_status}"
  ((FAIL++))
fi
echo ""

# 7. Blog freshness
echo "--- Blog Freshness ---"
if [ -d "blog" ]; then
  latest_file=""
  latest_epoch=0
  for f in blog/*/index.html; do
    [ "$f" = "blog/*/index.html" ] && continue
    file_epoch=$(stat -f '%m' "$f" 2>/dev/null || stat -c '%Y' "$f" 2>/dev/null)
    if [ -n "$file_epoch" ] && [ "$file_epoch" -gt "$latest_epoch" ]; then
      latest_epoch=$file_epoch
      latest_file=$f
    fi
  done
  if [ -n "$latest_file" ]; then
    now_epoch=$(date +%s)
    days_ago=$(( (now_epoch - latest_epoch) / 86400 ))
    if [ "$days_ago" -le 30 ]; then
      echo "  ✅ Latest post: ${latest_file} (${days_ago} days ago)"
      ((PASS++))
    else
      echo "  ⚠️  Latest post: ${latest_file} (${days_ago} days ago — STALE, needs new post)"
      ((WARN++))
    fi
  else
    echo "  ⚠️  No blog posts found in /blog/"
    ((WARN++))
  fi
else
  echo "  ⚠️  /blog/ directory not found — run from repo root"
  ((WARN++))
fi
echo ""

# 8. Check Open Graph tags on homepage
echo "--- Open Graph (Homepage) ---"
og_title=$(curl -s "${SITE}/" | grep -c 'og:title')
og_desc=$(curl -s "${SITE}/" | grep -c 'og:description')
if [ "$og_title" -gt 0 ] && [ "$og_desc" -gt 0 ]; then
  echo "  ✅ og:title and og:description present"
  ((PASS++))
else
  echo "  ❌ Missing Open Graph tags"
  ((FAIL++))
fi
echo ""

# Summary
echo "========================================="
echo "  SUMMARY"
echo "========================================="
echo "  ✅ Passed: ${PASS}"
echo "  ⚠️  Warnings: ${WARN}"
echo "  ❌ Failed: ${FAIL}"
echo ""
if [ "$FAIL" -gt 0 ]; then
  echo "  ACTION NEEDED: Fix failed checks above."
elif [ "$WARN" -gt 0 ]; then
  echo "  ATTENTION: Review warnings above."
else
  echo "  ALL CLEAR. Site is healthy."
fi
echo ""
echo "  MANUAL CHECK REMINDER:"
echo "  → Open Google Search Console and review:"
echo "    - Indexing status (are all pages indexed?)"
echo "    - Search performance (clicks, impressions, keywords)"
echo "    - Links report (external backlinks)"
echo "========================================="
