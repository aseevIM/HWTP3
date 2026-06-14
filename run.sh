#!/bin/bash

DATA_DIR="./data"

case "$1" in
    build_generator)
        echo "Building generator image..."
        docker build -t data_generator ./generator
        ;;
    run_generator)
        echo "Running generator..."
        mkdir -p "$DATA_DIR"
        docker run --rm -v "$(pwd)/data:/data" data_generator
        ;;
    create_local_data)
        echo "Creating local data..."
        mkdir -p ./local_data
        python3 generator/generate.py ./local_data
        ;;
    build_reporter)
        echo "Building reporter image..."
        docker build -t data_reporter ./reporter
        ;;
    run_reporter)
        echo "Running reporter..."
        mkdir -p "$DATA_DIR"
        docker run --rm -v "$(pwd)/data:/data" data_reporter
        ;;
    structure)
        echo "Project structure:"
        find . -type f -not -path "./.git/*" | sort
        ;;
    clear_data)
        echo "Clearing $DATA_DIR..."
        rm -f "$DATA_DIR"/*.csv "$DATA_DIR"/*.html
        echo "Done."
        ;;
    inside_generator)
        echo "Inside generator - /data contents:"
        docker run --rm -v "$(pwd)/data:/data" -it data_generator ls -la /data
        ;;
    inside_reporter)
        echo "Inside reporter - /data contents:"
        docker run --rm -v "$(pwd)/data:/data" -it data_reporter ls -la /data
        ;;
    report_server)
        echo "Starting web server on port 8080..."
        docker run -d -p 8080:80 -v "$(pwd)/data:/usr/share/nginx/html:ro" --name report_nginx nginx:alpine
        echo "✅ Server started!"
        echo "📍 Open in browser:"
        echo "   - Go to Ports tab → click on port 8080 → Open in Browser"
        echo "   - Add /report.html to the URL"
        ;;
    *)
        echo "❌ Unknown command: $1"
        echo ""
        echo "Available commands:"
        echo "  build_generator     - build Docker image for generator"
        echo "  run_generator       - generate data.csv"
        echo "  create_local_data   - run generator locally"
        echo "  build_reporter      - build Docker image for reporter"
        echo "  run_reporter        - generate report.html"
        echo "  structure           - show all files"
        echo "  clear_data          - delete data/ files"
        echo "  inside_generator    - check /data from generator"
        echo "  inside_reporter     - check /data from reporter"
        echo "  report_server       - start web server"
        exit 1
        ;;
esac
