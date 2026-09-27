{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- set name = custom_schema_name if custom_schema_name else target.schema -%}
    {%- if target.name == 'ci' -%}ci_{{ name }}{%- else -%}{{ name }}{%- endif -%}
{%- endmacro %}
