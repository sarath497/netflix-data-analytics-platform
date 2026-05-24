{% macro snowflake__create_view_as(relation, sql) -%}
  {%- set secure = config.get('secure', default=false) -%}
  {%- set copy_grants = config.get('copy_grants', default=false) -%}
  {%- set row_access_policy = config.get('row_access_policy', default=none) -%}
  {%- set table_tag = config.get('table_tag', default=none) -%}
  {%- set sql_header = config.get('sql_header', none) -%}

  {#-- Strip any trailing semicolons so Snowflake doesn't interpret it as a second statement. --#}
  {%- set sql = sql.rstrip(' \n\r;') -%}

  {{ sql_header if sql_header is not none }}
  create or replace {% if secure -%}
    secure
  {%- endif %} view {{ relation }}
  {% if config.persist_column_docs() -%}
    {% set model_columns = model.columns %}
    {% set query_columns = get_columns_in_query(sql) %}
    {{ get_persist_docs_column_list(model_columns, query_columns) }}

  {%- endif %}
  {%- set contract_config = config.get('contract') -%}
  {%- if contract_config.enforced -%}
    {{ get_assert_columns_equivalent(sql) }}
  {%- endif %}
  {% if copy_grants -%} copy grants {%- endif %}
  {% if row_access_policy -%} with row access policy {{ row_access_policy }} {%- endif %}
  {% if table_tag -%} with tag ({{ table_tag }}) {%- endif %}
  as
    {{ sql }}
{% endmacro %}
