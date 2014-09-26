java:
  pkg:
    - installed
    - name: {{ salt['pillar.get']('java:name') }}

elastic:
  pkg:
    - installed
    - name: elasticsearch
  service:
    - running
    - name: elasticsearch
    - require:
      - pkg: {{ salt['pillar.get']('java:name') }}
    - watch:
      - file: elastic_conf

elastic_htpasswd:
  file.managed:
    - name: {{ salt['pillar.get']('elastic:htpasswd_file') }}
    - contents_pillar: elastic:htpasswd
    - user: {{ salt['pillar.get']('kibana:apache:user') }}
    - group: {{ salt['pillar.get']('kibana:apache:group') }}
    - mode: 600
    - makedirs: True

elastic_conf:
  file.managed:
    - name: '/etc/elasticsearch/elasticsearch.yml'
    - contents: |+
          network.bind_host:  0.0.0.0
    - mode: 644

