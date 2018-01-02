application = 'madhav'
listen "/tmp/unicorn_#{application}.sock"
pid "/tmp/unicorn_#{application}.pid"
worker_processes 1;  # Please check this on **production environment** and ***MASTER BRANCH*
timeout 3600           # Please check this on **production environment** and ***MASTER BRANCH*
preload_app true

shared_path = "/srv/projects/#{application}/shared"
stderr_path "#{shared_path}/log/unicorn.stderr.log"
stdout_path "#{shared_path}/log/unicorn.stdout.log"

before_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end

  old_pid = "/tmp/unicorn_#{application}.pid.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end

after_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end
end
