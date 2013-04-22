# tell Rack (and Sprockets) about modern font MIME types:
Rack::Mime::MIME_TYPES['.woff'] = 'application/x-font-woff'
Rack::Mime::MIME_TYPES['.ttf'] = 'application/octet-stream'
Rack::Mime::MIME_TYPES['.svg'] = 'image/svg+xml'
