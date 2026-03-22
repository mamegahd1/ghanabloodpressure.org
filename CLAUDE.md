# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Static HTML/CSS website for the Ghana Hypertension Screening Initiative (GHSI), hosted on GitHub Pages at **ghanabloodpressure.org**. No build tools, frameworks, or backend — pure HTML served directly.

## Deployment

Push to `main` branch → GitHub Pages serves automatically. The `CNAME` file maps to `ghanabloodpressure.org`. No build step required.

## Architecture

**Every page is a self-contained HTML file** with all CSS (~700+ lines) embedded inline in a `<style>` tag. There are no external stylesheets or shared CSS files. This means CSS changes must be replicated across all 6 pages:

- `index.html` — Homepage
- `approach/index.html` — Our Approach
- `pilot/index.html` — The Pilot
- `team/index.html` — Team & Partners
- `research/index.html` — Research
- `involved/index.html` — Get Involved

**Shared structure across all pages:**
1. Countdown banner (World Hypertension Day — May 17) with Ko-fi donation link
2. Sticky navigation bar with mobile hamburger toggle
3. Page-specific main content
4. Footer with links and contact info

**JavaScript is minimal** — countdown timer calculation and mobile nav toggle only, all inline.

## Design System

CSS custom properties defined in `:root` on every page:

- **Primary**: `--teal` (#1A5F5F), `--teal-dark`, `--teal-light`
- **Navigation**: `--burgundy-deep` (#4A1525), `--burgundy`
- **Accent**: `--gold` (#C9A227), `--gold-light`, `--gold-pale`
- **Background**: `--cream` (#FDFAF5), `--cream-dark`
- **Text**: `--charcoal` (#2C2C2C), `--charcoal-light`

**Fonts** (Google Fonts): `DM Sans` (body), `Playfair Display` (headings).

**Responsive breakpoints**: 768px and 1024px.

## Critical Patterns

- **CSS duplication**: Any style change needs to be applied to all 6 HTML files.
- **SVG graphics are inline**: Hero sections contain large inline SVGs with gradients and custom illustrations (Adinkra-inspired patterns, healthcare scenes).
- **External links**: Ko-fi for donations, research papers on PLOS ONE and Frontiers in Public Health.
- **Accessibility**: Skip-nav link, ARIA labels, semantic HTML, focus-visible outlines, 44px minimum touch targets.
