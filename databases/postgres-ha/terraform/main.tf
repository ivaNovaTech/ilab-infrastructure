resource "postgresql_database" "pacs" {
  name       = "pacs"
  owner      = "pacs"
  lc_collate = "en_US.UTF-8"
}

resource "postgresql_database" "airflow" {
  name       = "airflow"
  owner      = "postgres"
  lc_collate = "en_US.UTF-8"
}

resource "postgresql_database" "vitals" {
  name       = "vitals"
  owner      = "postgres"
  lc_collate = "en_US.UTF-8"
}