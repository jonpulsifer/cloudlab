resource "google_bigquery_dataset" "sticky" {
  dataset_id                  = "sticky"
  friendly_name               = "sticky"
  description                 = "This is where we hold the data we glued together"
  location                    = "us-east4"
  default_table_expiration_ms = 3600000

  labels = {
    env = "production"
  }
}

resource "google_bigquery_table" "records" {
  dataset_id = google_bigquery_dataset.sticky.dataset_id
  table_id   = "records"

  time_partitioning {
    type = "DAY"
  }

  labels = {
    env = "production"
  }

  schema = <<EOF
[
  {
    "name": "email",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "email of the user"
  },
  {
    "name": "score",
    "type": "INTEGER",
    "mode": "NULLABLE",
    "description": "the user has a score"
  }
]
EOF

}
