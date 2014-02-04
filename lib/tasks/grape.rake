task :routes do
  Sepia::API.routes.each do |r|
    method = r.route_method.ljust(10)
    path   = r.route_path
    puts "     #{method} #{path}"
  end
end
