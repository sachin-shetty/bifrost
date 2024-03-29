{{ define "bifrost.nginx_conf" }}

# Instantiated from {{ .Release.Name }}

#worker_processes  auto;

#pid        logs/nginx.pop.pid;

#events {
#    worker_connections  1024;
#}



    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  logs/access.pop.log  main;
    error_log  logs/error.pop.log debug;

    #tcp_nopush     on;

    #keepalive_timeout  65;

    #gzip  on;

    init_by_lua_block {
        local cjson = require("cjson")
        local file_path = "/usr/local/openresty/nginx/bifrost/routes.json"
        local f = io.open(file_path, "r")
        local content = f:read("*a")
        f:close()
        ngx.log(ngx.INFO, "Loading routes: ", content)
        routes = cjson.decode(content)
    }

    upstream router {          
        server 0.0.0.1;

        balancer_by_lua_block {
            local balancer = require "ngx.balancer"
            local forward_address = routes[ngx.var.http_host]
            if forward_address == nil then
                ngx.log(ngx.ERR, "could not find a mapping for: ", ngx.var.http_host)
                return ngx.exit(400)
            end

            ngx.log(ngx.INFO, "Connecting to upstream: ", ngx.var.http_host, "=", forward_address)
            local ok, err = balancer.set_current_peer(forward_address, 443)
            if not ok then
                ngx.log(ngx.ERR, "failed to set the current peer: ", err, ngx.var.http_host, forward_address)
                return ngx.exit(500)
            end
        }

        keepalive 500;
    }

    server {
        {{ if .Values.bifrost.tls.enabled }}
        listen *:4443 ssl;
        ssl_certificate ssl/localhost.crt;
        ssl_certificate_key ssl/localhost.key;
        {{ else }}
        listen *:4443;
        {{ end }}

        # Send header
        add_header "X-Bifrost-Via" "{{ .Release.Name }}";

        location /speed-test-{{ .Release.Name }} {
            sendfile           on;
            alias /speed-test;
        }

        location / {
            proxy_http_version 1.1;
            proxy_set_header Connection "";
            proxy_ssl_server_name on;
            proxy_ssl_protocols TLSv1.2 TLSv1.3;
            proxy_set_header Host $host;
            proxy_ssl_session_reuse on;
            proxy_ssl_verify off;
            proxy_pass https://router;
        }
    }

    server {
        listen *:80; 

        location / {
            return 200;
        }
        
    }


    server_tokens       off;

{{ end }}
