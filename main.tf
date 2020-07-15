# Terraform > Provider
# https://www.terraform.io/docs/modules/index.html
# https://www.terraform.io/docs/providers

terraform {
  backend "gcs" {}
}

provider "google-beta" {
  region              = "${var.region}"
}

# Google Cloud Platform > Project

module "project" {
  source              = "git::ssh://git@github.com/telus/cloud-modules.git//cloud/gcp/project?ref=v6.3.0"
  folder_id           = "${var.folder_id}"
  billing_account_id  = "${var.billing_account_id}"
  project_id          = "${var.project_id}"
  project_name        = "${var.project_name}"
  services            = "${var.services}"
}

# IAM Bindings
# --------------------------------------------------------------------


# bigquery module details
# --------------------------------------------------------------------

module "bigquery" {
  source                     = "../.."
  dataset_id                 = "foo"
  dataset_name               = "foo"
  description                = "some description"
  project_id                 = var.project_id
  location                   = "US"
  delete_contents_on_destroy = var.delete_contents_on_destroy
  tables = [
    {
      table_id          = "bar",
      schema            = "sample_bq_schema.json",
      time_partitioning = null,
      expiration_time   = 2524604400000, # 2050/01/01
      clustering        = [],
      labels = {
        env      = "devops"
        billable = "true"
        owner    = "joedoe"
      },
    }
  ]
  dataset_labels = {
    env      = "dev"
    billable = "true"
    owner    = "janesmith"
  }
}
