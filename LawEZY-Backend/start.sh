#!/bin/bash

# =========================================================================
# LawEZY Monolithic Orchestration Script
# Designed for Render / Cost-Efficient Single-Process Deployments
# =========================================================================

# High-Performance JVM flags tailored for running a unified monolith in low RAM (512MB-1GB)
JVM_FLAGS="-XX:+UseContainerSupport -Xmx512m -XX:+UseG1GC -XX:G1ReservePercent=15 -XX:InitiatingHeapOccupancyPercent=45 -Djava.security.egd=file:/dev/./urandom"

echo "=== Starting LawEZY Monolithic Backend Ecosystem ==="

# Get Render's public port or fallback to 8080
PORT=${PORT:-8080}

echo "Launching LawEZY-Backend on port $PORT..."
java $JVM_FLAGS -jar target/lawezy-backend-0.0.1-SNAPSHOT.jar --server.port=$PORT
