#!/bin/bash

# =========================================================================
# LawEZY Container Orchestration Script
# Designed for Render / Cost-Efficient Multi-Process Deployments
# =========================================================================

# Strict memory caps per service to fit all 5 JVMs within a 1GB/512MB RAM environment
# GC optimizations are configured to aggressively return unused memory to the OS
JVM_FLAGS="-XX:+UseContainerSupport -Xmx192m -XX:+UseG1GC -XX:G1ReservePercent=15 -XX:InitiatingHeapOccupancyPercent=45 -Djava.security.egd=file:/dev/./urandom"
GATEWAY_FLAGS="-XX:+UseContainerSupport -Xmx256m -XX:+UseG1GC -XX:G1ReservePercent=15 -XX:InitiatingHeapOccupancyPercent=45 -Djava.security.egd=file:/dev/./urandom"

# Ensure all logs go to standard output with service prefixes for easy debugging in Render
echo "=== Starting LawEZY Microservices Ecosystem ==="

# 1. Start Identity Service (port 8081)
echo "Starting lawezy-identity-service..."
java $JVM_FLAGS -jar lawezy-identity-service.jar --server.port=8081 &

# 2. Start Chat Service (port 8082)
echo "Starting lawezy-chat-service..."
java $JVM_FLAGS -jar lawezy-chat-service.jar --server.port=8082 &

# 3. Start Finance Service (port 8083)
echo "Starting lawezy-finance-service..."
java $JVM_FLAGS -jar lawezy-finance-service.jar --server.port=8083 &

# 4. Start Notification Service (port 8084)
echo "Starting lawezy-notification-service..."
java $JVM_FLAGS -jar lawezy-notification-service.jar --server.port=8084 &

# Wait for background services to initialize and register ports
echo "Waiting for services to warm up (15 seconds)..."
sleep 15

# Print status of processes
echo "Background service status:"
ps aux | grep java

# 5. Start Gateway Service in the foreground (mapped to Render's public port)
RENDER_PORT=${PORT:-10000}
echo "Starting lawezy-gateway on port $RENDER_PORT..."
java $GATEWAY_FLAGS -jar lawezy-gateway.jar --server.port=$RENDER_PORT
