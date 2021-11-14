using Genie.Configuration, Logging

config = Settings(
  server_port = rand(8400:8700),
  server_host = "localhost",
  log_level = Logging.Info,
  log_to_file = false,
  server_handle_static_files = true,
  path_build = "build",
  format_julia_builds = true,
  format_html_output = true,
)
