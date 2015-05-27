-- Create table modes
--
-- Table: modes

DROP TABLE modes;

CREATE TABLE modes
(
  id serial NOT NULL,
  mode_name character varying(255),
  created_at timestamp without time zone,
  updated_at timestamp without time zone,
  mode_id integer NOT NULL,
  CONSTRAINT modes_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE modes
  OWNER TO liulu;

-- Index: mode_id_idx

DROP INDEX mode_id_idx;

CREATE UNIQUE INDEX mode_id_idx
  ON modes
  USING btree
  (mode_id);

-- Create table switch_types
--
-- Table: switch_types

DROP TABLE switch_types;

CREATE TABLE switch_types
(
  id serial NOT NULL,
  type_name character varying(255),
  created_at timestamp without time zone,
  updated_at timestamp without time zone,
  type_id integer NOT NULL,
  CONSTRAINT switch_types_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE switch_types
  OWNER TO liulu;


-- Create table edges
DROP TABLE edges;

CREATE TABLE edges
(
  id serial NOT NULL,
  length double precision,
  speed_factor double precision,
  created_at timestamp without time zone,
  updated_at timestamp without time zone,
  mode_id integer NOT NULL,
  from_id bigint NOT NULL,
  to_id bigint NOT NULL,
  edge_id bigint NOT NULL,
  raw_link_id bigint,
  CONSTRAINT edges_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE edges
  OWNER TO liulu;

-- Index: edge_id_idx

DROP INDEX edge_id_idx;

CREATE INDEX edge_id_idx
  ON edges
  USING btree
  (edge_id);

-- Index: edge_mode_idx

DROP INDEX edge_mode_idx;

CREATE INDEX edge_mode_idx
  ON edges
  USING btree
  (mode_id);
ALTER TABLE edges CLUSTER ON edge_mode_idx;

-- Index: from_idx

DROP INDEX from_idx;

CREATE INDEX from_idx
  ON edges
  USING btree
  (from_id);

-- Index: to_idx

DROP INDEX to_idx;

CREATE INDEX to_idx
  ON edges
  USING btree
  (to_id);

-- Create table vertices

-- Table: vertices

DROP TABLE vertices;

CREATE TABLE vertices
(
  id serial NOT NULL,
  out_degree integer,
  created_at timestamp without time zone,
  updated_at timestamp without time zone,
  first_edge double precision,
  vertex_id bigint NOT NULL,
  mode_id integer NOT NULL,
  x double precision,
  y double precision,
  CONSTRAINT vertices_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE vertices
  OWNER TO liulu;

-- Index: vertex_id_idx

DROP INDEX vertex_id_idx;

CREATE UNIQUE INDEX vertex_id_idx
  ON vertices
  USING btree
  (vertex_id);

-- Index: vertex_mode_idx

DROP INDEX vertex_mode_idx;

CREATE INDEX vertex_mode_idx
  ON vertices
  USING btree
  (mode_id);
ALTER TABLE vertices CLUSTER ON vertex_mode_idx;

-- Create table switch_points
--
-- Table: switch_points

DROP TABLE switch_points;

CREATE TABLE switch_points
(
  id serial NOT NULL,
  cost double precision,
  is_available boolean,
  created_at timestamp without time zone,
  updated_at timestamp without time zone,
  from_mode_id integer NOT NULL,
  to_mode_id integer NOT NULL,
  type_id integer NOT NULL,
  from_vertex_id bigint NOT NULL,
  to_vertex_id bigint NOT NULL,
  switch_point_id bigint,
  ref_poi_id bigint,
  CONSTRAINT switch_points_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE switch_points
  OWNER TO liulu;

-- Index: mode_id_pair_idx

DROP INDEX mode_id_pair_idx;

CREATE INDEX mode_id_pair_idx
  ON switch_points
  USING btree
  (from_mode_id, to_mode_id);
ALTER TABLE switch_points CLUSTER ON mode_id_pair_idx;

-- Index: type_id_idx

DROP INDEX type_id_idx;

CREATE INDEX type_id_idx
  ON switch_points
  USING btree
  (type_id);


