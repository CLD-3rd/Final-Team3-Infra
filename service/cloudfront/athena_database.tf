# Glue Database
resource "aws_glue_catalog_database" "cloudfront_logs_db" {
  name = "${var.name_prefix}_cloudfront_logs_db"
}

# Glue Table (CloudFront Logs)
resource "aws_glue_catalog_table" "cloudfront_logs_table" {
  name          = "cloudfront_logs"
  database_name = aws_glue_catalog_database.cloudfront_logs_db.name

  table_type = "EXTERNAL_TABLE"

  parameters = {
    "classification"         = "cloudfront"
    "compressionType"        = "none"
    "typeOfData"             = "file"
    "skip.header.line.count" = "2"
  }

  storage_descriptor {
    # S3 버킷 생성 시에 사용하는 구문
    # location      = "s3://${aws_s3_bucket.cloudfront_log_bucket.bucket}/cloudfront-logs/"  # 실제 로그 경로
    # 존재하는 S3 버킷 참조 시에 사용하는 구문
    location = "s3://${data.aws_s3_bucket.cloudfront_log_bucket.bucket}/cloudfront-logs/"
    
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      name                  = "cloudfront-serde"
      serialization_library = "org.apache.hadoop.hive.serde2.RegexSerDe"

      parameters = {
        "input.regex"         = "^(\\S+)\\s(\\S+)\\s(\\S+)\\s(\\S+)\\s(\\S+)\\s(\\S+)\\s(\\S+)\\s(\\S+)\\s(\\S+)\\s(\\S+)\\s(\\S+)\\s(\\S+)\\s(\\S+)\\s(\\S+)\\s(\\S+)\\s(\\S+)\\s(\\S+)\\s(\\S+)\\s(\\S+)\\s(\\S+)\\s(\\S+)\\s(\\S+)\\s(\\S+)\\s(\\S+)\\s(\\S+)\\s(\\S+)\\s(\\S+)\\s(\\S+).*"
        "serialization.format" = "1"
      }
    }

    columns {
      name = "date"
      type = "string"
    }
    columns {
      name = "time"
      type = "string"
    }
    columns {
      name = "x_edge_location"
      type = "string"
    }
    columns {
      name = "sc_bytes"
      type = "bigint"
    }
    columns {
      name = "c_ip"
      type = "string"
    }
    columns {
      name = "cs_method"
      type = "string"
    }
    columns {
      name = "cs_host"
      type = "string"
    }
    columns {
      name = "cs_uri_stem"
      type = "string"
    }
    columns {
      name = "sc_status"
      type = "int"
    }
    columns {
      name = "cs_referer"
      type = "string"
    }
    columns {
      name = "cs_user_agent"
      type = "string"
    }
    columns {
      name = "cs_uri_query"
      type = "string"
    }
    columns {
      name = "cs_cookie"
      type = "string"
    }
    columns {
      name = "x_edge_result_type"
      type = "string"
    }
    columns {
      name = "x_edge_request_id"
      type = "string"
    }
    columns {
      name = "x_host_header"
      type = "string"
    }
    columns {
      name = "cs_protocol"
      type = "string"
    }
    columns {
      name = "cs_bytes"
      type = "bigint"
    }
    columns {
      name = "time_taken"
      type = "double"
    }
    columns {
      name = "x_forwarded_for"
      type = "string"
    }
    columns {
      name = "ssl_protocol"
      type = "string"
    }
    columns {
      name = "ssl_cipher"
      type = "string"
    }
    columns {
      name = "x_edge_response_result_type"
      type = "string"
    }
    columns {
      name = "cs_protocol_version"
      type = "string"
    }
    columns {
      name = "fle_status"
      type = "string"
    }
    columns {
      name = "fle_encrypted_fields"
      type = "int"
    }
    columns {
      name = "c_port"
      type = "int"
    }
    columns {
      name = "time_to_first_byte"
      type = "double"
    }
    columns {
      name = "x_edge_detailed_result_type"
      type = "string"
    }
    columns {
      name = "sc_content_type"
      type = "string"
    }
  }
}
