#!/bin/bash

db_name=$1
db_user=$2
csv_dir=$3
# 1. backup old database if it exists
pg_dump -h localhost -p 5432 -U $db_user -Fc -b -v -f "./bak/old_$db_name.backup" $db_name
# ~1. create a new database if it does not exist
#createdb -O $db_user $db_name
#psql -d $db_name -U $db_user -c "CREATE EXTENSION postgis;"
# 2. create initial multimodal graph tables including
# modes, switch_types, edges, vertices and switch_points, populate initial data in 
# modes and switch_types
psql -d $db_name -U $db_user -f prepare_graph_tables.sql
psql -d $db_name -U $db_user -c "\COPY modes (id,mode_name,created_at,updated_at,mode_id) FROM '$csv_dir/modes.csv' WITH CSV HEADER"
psql -d $db_name -U $db_user -c "\COPY switch_types (id,type_name,created_at,updated_at,type_id) FROM '$csv_dir/switch_types.csv' WITH CSV HEADER"
# 3. import shapefiles with overriding the old geometry tables
for shp_file in ./shp/*.shp
do
    echo "Importing $shp_file... "
    shp2pgsql -d -s 4326 -W latin1 $shp_file | psql -h localhost -d $db_name -U $db_user 
    echo "done!"
done
# 4. create pgis_fn_nn function in database
psql -d $db_name -U $db_user -f pgis_nn.sql
# 5. import/generate edges, vertices and switch_points
psql -d $db_name -U $db_user -c "\COPY edges (id,edge_id,from_id,to_id,length,speed_factor,mode_id,created_at,updated_at) FROM '$csv_dir/edges.csv' WITH CSV HEADER"
psql -d $db_name -U $db_user -c "\COPY vertices (id,vertex_id,mode_id,out_degree,first_edge,x,y,created_at,updated_at) FROM '$csv_dir/vertices.csv' WITH CSV HEADER"
psql -d $db_name -U $db_user -f switch_points_generator.sql
# 6. validate generated multimodal graphs
echo "======== Validating multimodal graph... ========"
psql -d $db_name -U $db_user -f validate_graph.sql
# 7. backup this database
pg_dump -h localhost -p 5432 -U $db_user -Fc -b -v -f "./bak/new_$db_name.backup" $db_name
