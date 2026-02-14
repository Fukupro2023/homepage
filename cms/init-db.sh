#!/bin/bash
set -e
# postgres スーパーユーザーで追加DBを作成し、cms に権限付与
psql -v ON_ERROR_STOP=1 --username "postgres" <<-EOSQL
  CREATE DATABASE cms_production_cache;
  CREATE DATABASE cms_production_queue;
  CREATE DATABASE cms_production_cable;
  GRANT ALL PRIVILEGES ON DATABASE cms_production_cache TO cms;
  GRANT ALL PRIVILEGES ON DATABASE cms_production_queue TO cms;
  GRANT ALL PRIVILEGES ON DATABASE cms_production_cable TO cms;
EOSQL
