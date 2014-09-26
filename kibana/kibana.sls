{% set server_name = salt['pillar.get']('kibana:site_name', 'ss') %}
{% set wwwhome = salt['pillar.get']('kibana:wwwhome', '/var/www') %}
{% set kibana_wwwroot = wwwhome + '/' + server_name + '/' %}

kibana_static_dir:
  file.directory:
    - name: {{ kibana_wwwroot }};
    - user: {{ salt['pillar.get']('kibana:apache:user') }}
    - group: {{ salt['pillar.get']('kibana:apache:group') }}
    - mode: 755
    - makedirs: True

kibana_config_js:
  file.managed:
    - name: '{{ kibana_wwwroot }}/kibana-{{ salt['pillar.get']('kibana:version') }}/config.js'
    - template: jinja
    - source: salt://kibana/files/config.js
    - makedirs: True
    - context:
       kibana_port: {{ salt['pillar.get']('kibana:httpport') }}

kibana_apache_conf:
  file.managed:
    - template: jinja
    - source: salt://kibana/files/apache_kibana_site
    - name: {{ salt['pillar.get']('kibana:apache:confdir') }}/kibana.conf
    - mode: 644
    - makedirs: True
    - context:
        kibana_wwwroot: {{ kibana_wwwroot }}
        elastic_htpasswd_file: {{ salt['pillar.get']('elastic:htpasswd_file') }}
        kibana_version: {{ salt['pillar.get']('kibana:version') }}
       

kibana:
  archive.extracted:
    - name: {{ kibana_wwwroot }}
    - source: https://download.elasticsearch.org/kibana/kibana/kibana-{{ salt['pillar.get']('kibana:version') }}.tar.gz
    - archive_format: tar
    - tar_options: v
    - if_missing: /tmp/kibana
    - source_hash: md5={{ salt['pillar.get']('kibana:md5') }}
