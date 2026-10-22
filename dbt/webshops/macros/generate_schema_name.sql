{#-
  Decides which schema each model is written to.
  Uses the schema set for the model (silver, gold); if none is set, falls back to the default from profiles.yml.
  When running with --target ci, it adds a "ci_" prefix (ci_silver, ci_gold) so test runs don't overwrite the real tables.
-#}
{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- set name = custom_schema_name if custom_schema_name else target.schema -%}
    {%- if target.name == 'ci' -%}ci_{{ name }}{%- else -%}{{ name }}{%- endif -%}
{%- endmacro %}
