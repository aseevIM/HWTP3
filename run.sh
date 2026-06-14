case "$1" in
    build_generator)
        docker build -t data_generator ./generator
        ;;
    run_generator)
        mkdir -p ./data
        docker run --rm -v "$(pwd)/data:/data" data_generator
        ;;
    build_reporter)
        docker build -t data_reporter ./reporter
        ;;
    run_reporter)
        mkdir -p ./data
        docker run --rm -v "$(pwd)/data:/data" data_reporter
        ;;
    create_local_data)
        mkdir -p ./local_data
        python3 generator/generate.py ./local_data
        ;;
    structure)
        find . -type f -not -path "./.git/*" | sort
        ;;
    clear_data)
        rm -f ./data/*.csv ./data/*.html
        ;;
    inside_generator)
        docker run --rm -v "$(pwd)/data:/data" -it data_generator ls -la /data
        ;;
    inside_reporter)
        docker run --rm -v "$(pwd)/data:/data" -it data_reporter ls -la /data
        ;;
    report_server)
        docker run -d -p 8080:80 -v "$(pwd)/data:/usr/share/nginx/html:ro" --name report_nginx nginx:alpine
        echo "Server started on http://localhost:8080/report.html"
        ;;
    *)
        echo "Commands: build_generator, run_generator, build_reporter, run_reporter, create_local_data, structure, clear_data, inside_generator, inside_reporter, report_server"
        ;;
esac
