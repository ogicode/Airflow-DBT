-- naming
-- overrides dbt's built-in schema naming
-- custom_schema_name = value of +schema in dbt_project.yml (bronze/silver/gold)
-- node = the model being built (not used here)
{% macro generate_schema_name(custom_schema_name, node) %}
    {{ custom_schema_name or target.schema }}
{% endmacro %}