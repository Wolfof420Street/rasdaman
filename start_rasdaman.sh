#!/bin/bash

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Function to check if services are running
check_services() {
    echo "Checking Rasdaman services..."
    if curl -s http://localhost:8080/rasdaman/ows > /dev/null; then
        echo "✅ Rasdaman is running"
    else
        echo "❌ Rasdaman is not responding"
    fi
    
    if curl -s http://localhost:8081/petascope/ows > /dev/null; then
        echo "✅ Petascope is running"
    else
        echo "❌ Petascope is not responding"
    fi
}

# Function to start services
start_services() {
    echo "Starting Rasdaman services..."
    docker-compose up -d
    
    echo "Waiting for services to start..."
    sleep 10
    
    check_services
}

# Function to stop services
stop_services() {
    echo "Stopping Rasdaman services..."
    docker-compose down
}

# Function to show logs
show_logs() {
    docker-compose logs -f
}

# Main script
case "$1" in
    "start")
        start_services
        ;;
    "stop")
        stop_services
        ;;
    "restart")
        stop_services
        start_services
        ;;
    "status")
        check_services
        ;;
    "logs")
        show_logs
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status|logs}"
        echo "  start   - Start Rasdaman services"
        echo "  stop    - Stop Rasdaman services"
        echo "  restart - Restart Rasdaman services"
        echo "  status  - Check service status"
        echo "  logs    - Show service logs"
        exit 1
        ;;
esac 