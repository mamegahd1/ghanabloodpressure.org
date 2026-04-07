# GHSI Website Operations Guide

## Ownership

| Area | Owner | Tools |
|------|-------|-------|
| Website content and strategy | Mavis + Nana (Claude Pro) | Claude.ai for drafting |
| Website deployment | Claude Code | GitHub CLI, git push |
| Social media | Augustina Hounnou | TBD |
| SEO health monitoring | Claude Code (automated) + Mavis (Search Console) | see below |

## Blog Workflow

Frequency: One post per month, minimum.

1. Mavis and Nana confirm the topic and draft content in Claude.ai
2. Mavis provides the final draft to Claude Code
3. Claude Code creates the post using the template at /blog/blog-post-template.html
4. Claude Code adds the new post to /blog/index.html
5. Claude Code adds the new URL to /sitemap.xml with current date
6. Claude Code commits and pushes with message: "Blog: [post title]"

### Blog Post Checklist (for Claude Code)
- [ ] Create new folder: /blog/[slug]/index.html
- [ ] Use blog-post-template.html structure
- [ ] Include: title, meta description, keywords, canonical URL, OG tags, Twitter tags, Article JSON-LD
- [ ] Add post card to /blog/index.html (newest post at top)
- [ ] Add URL to sitemap.xml
- [ ] Commit and push

### Monthly Content Calendar (2026)
- May: World Hypertension Day activation recap
- June: Partner spotlight
- July: Curriculum finalization update
- August: Regulatory clearance progress
- September: Pilot preparation update
- October: Community volunteer recruitment
- November: Pre-pilot countdown
- December: Pilot launch announcement

## Monthly SEO Health Check

Run /scripts/seo-health-check.sh on the first of each month.

The script checks:
1. All pages return HTTP 200
2. Each page has a unique <title> tag
3. Each page has a <meta name="description">
4. Homepage has JSON-LD schema markup
5. sitemap.xml is accessible
6. robots.txt is accessible
7. Blog freshness: warns if no new post in 30+ days

### What Claude Code cannot check (Mavis does manually):
- Google Search Console: indexing status, keyword rankings, clicks
- Backlink count: check in Search Console > Links

## Technical Constraints
- All mailto links must be plain text (not Cloudflare protected)
- Form endpoint: formspree.io/f/xjgvlazg
- Do not modify existing page content unless explicitly instructed
- Do not remove any existing functionality or inline SVG illustrations
