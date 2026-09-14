#!/bin/bash

# ==============================================================================
# Script Name : Task4_system_checks.sh
# Author      : LAMPTEY AKWELEY HANNABEL
# Date        : September 2026
# Description : Executes system health and dependency checks.
# ==============================================================================

# ------------------------------------------------------------------------------
# Usage / Help Function
# ------------------------------------------------------------------------------
show_help() {
    echo "Usage: $0 [-h|--help]"
    echo ""
    echo "Description:"
    echo "  Runs a series of 4 automated system health checks:"
    echo "    1. Network Reachability (ping)"
    echo "    2. Disk Space Availability"
    echo "    3. Configuration File Verification"
    echo "    4. Tool Dependency Check"
    echo ""
    echo "Options:"
    echo "  -h, --help    Display this help message and exit."
    exit 0
}

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_help
fi

echo "==================================="
echo "    TASK 4: SYSTEM HEALTH CHECKS   "
echo "==================================="

# ------------------------------------------------------------------------------
# Check 1: Network Reachability
# ------------------------------------------------------------------------------
echo -n "[1/4] Checking Network Reachability (1.1.1.1)... "
if ping -c 1 1.1.1.1 > /dev/null 2>&1; then
    echo "SUCCESS"
else
    echo "FAILED"
fi

# ------------------------------------------------------------------------------
# Check 2: Disk Space Availability (>10% free)
# ------------------------------------------------------------------------------
echo -n "[2/4] Checking Free Disk Space on Root (/)... "
FREE_SPACE=$(df / | awk 'NR==2 {print 100 - $5}')
if [ "$FREE_SPACE" -gt 10 ]; then
    echo "SUCCESS (${FREE_SPACE}% available)"
else
    echo "FAILED (${FREE_SPACE}% available)"
fi

# ------------------------------------------------------------------------------
# Check 3: Configuration File Readability
# ------------------------------------------------------------------------------
CONFIG_FILE="/etc/passwd"
echo -n "[3/4] Checking Readability of $CONFIG_FILE... "
if [ -r "$CONFIG_FILE" ]; then
    echo "SUCCESS"
else
    echo "FAILED"
fi

# ------------------------------------------------------------------------------
# Check 4: Tool / Command Dependency Check
# ------------------------------------------------------------------------------
TOOL="git"
echo -n "[4/4] Checking Installation of '$TOOL'... "
if command -v "$TOOL" > /dev/null 2>&1; then
    echo "SUCCESS"
else
    echo "FAILED"
fi

echo "==================================="
echo "Checks Completed."
