if Rails.env == "production"
  SQL_HOST = "localhost"
  SQL_PORT = 5432
  SQL_DB = "dashboard"
  SQL_USER = "dashboard"
  SQL_PASS = "c@talin.ro"
else
  SQL_HOST = "localhost"
  SQL_PORT = 5432
  SQL_DB = "stylitics-dev"
  SQL_USER = "catalystww"
  SQL_PASS = ""
end