# Multimodal graph database builder for UntiedMaps dataset

Create multimodal graph database and populate data provided by UnitedMaps (UM) into it

## Usage

All the work can be done with the integrated script populate_mmrp_data.sh. Sample usage of the script:

```bash
$ ./populate_mmrp_data.sh YOURDATABASE USERNAME CSV_DIR_OF_EDGES_AND_VERTICES
```

## Major steps

1. backup old database if it exists, or create a fresh new one with postgis extension
2. create initial multimodal graph tables including `modes`, `switch_types`, `edges`, `vertices` and `switch_points`, populate initial data in `modes` and `switch_types`
3. import UM shapefiles to database
4. create `pgis_fn_nn` function in database
5. import/generate edges, vertices and switch_points
6. validate generated multimodal graphs
7. backup this database
