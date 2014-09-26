{% if salt['grains.get']('os_family') == 'Debian' -%}

elastic_repo:
  pkgrepo:
    - managed
    - name: deb http://packages.elasticsearch.org/elasticsearch/1.3/debian stable main
    - file: /etc/apt/sources.list.d/elasticsearch.list
    - require:
      - cmd: repo_add_gpg

logstash_repo:
  pkgrepo:
    - managed
    - name: deb http://packages.elasticsearch.org/logstash/1.4/debian stable main
    - file: /etc/apt/sources.list.d/logstash.list
    - require:
      - cmd: repo_add_gpg

repo_add_gpg:
  cmd:
    - wait
    - name: /usr/bin/apt-key add /var/tmp/elasticsearch.gpg
    - watch:
      - file: repo_gpg_file

repo_gpg_file:
  file:
    - managed
    - name: /var/tmp/elasticsearch.gpg
    - source: salt://kibana/files/elasticsearch.gpg

{%- elif salt['grains.get']('os_family') == 'RedHat' -%}
elastic_repo:
  pkgrepo:
    - managed
    - name: elasticsearch
    - humanname: Elasticsearch repository for 1.3.x packages
    - baseurl: http://packages.elasticsearch.org/elasticsearch/1.3/centos
    - gpgcheck: 1
    - enabled: 1
    - gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-ELASTIC
    - require:
      - file: repo_gpg_file

logstash_repo:
  pkgrepo:
    - managed
    - name: logstash
    - humanname: logstash repository for 1.3.x packages
    - baseurl: http://packages.elasticsearch.org/logstash/1.3/centos
    - gpgcheck: 1
    - enabled: 1
    - gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-ELASTIC
    - require:
      - file: repo_gpg_file

repo_gpg_file:
  file:
    - managed
    - name: /etc/pki/rpm-gpg/RPM-GPG-KEY-ELASTIC
    - source: salt://kibana/files/elasticsearch.gpg
{% endif %}
